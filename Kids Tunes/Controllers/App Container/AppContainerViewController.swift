//
//  AppContainerViewController.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/17/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit
import StoreKit

enum AccessoryViewVisibility {
    case hidden
    case shown
}

class AppContainerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var accessoryBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var accessoryContainerView: UIView!
    @IBOutlet weak var albumArtworkContainerView: UIView!
    @IBOutlet weak var albumArtworkImageView: UIImageView!
    @IBOutlet weak var tabBar: UITabBar!

    public var viewControllers = [UIViewController]() {
        didSet {
            configureViewControllers()
        }
    }

    private var tabBarHeightConstraint: NSLayoutConstraint!
    private var expandedHeight: CGFloat = UIScreen.main.bounds.width - 15
    private var selectedViewController: UIViewController?
    private var accessoryVisibility: AccessoryViewVisibility = .hidden
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.sessionStateDidChange), name: .sessionStatusChanged, object: nil)
        tabBar.delegate = self
        tabBarHeightConstraint = NSLayoutConstraint(item: tabBar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tabBar.sizeThatFits(CGSize.zero).height)
        tabBar.addConstraint(tabBarHeightConstraint)
        updateView(visibility: accessoryVisibility, false)
        albumArtworkContainerView.addDropshadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyzeSession()
        initMusicService()
    }
    
    private func setupViewControllers() {
        let musicViewController = UIStoryboard.init(name: "Music", bundle: nil).instantiateViewController(withIdentifier: "topMusicController") as! TopMusicViewController
        let musicTabBarImage = UIImage(named: "tab_bar_music")
        let musicTabBarItem = UITabBarItem(title: "Music", image: musicTabBarImage, tag: 0)
        musicViewController.tabBarItem = musicTabBarItem
        
        let favoritesViewController = UIStoryboard.init(name: "Favorites", bundle: nil).instantiateViewController(withIdentifier: "favoritesController") as! FavoritesViewController
        let favoritesTabBarImage = UIImage(named: "tab_bar_heart")
        let favoritesTabBarItem = UITabBarItem(title: "Favorites", image: favoritesTabBarImage, tag: 0)
        favoritesViewController.tabBarItem = favoritesTabBarItem
        
        let accountViewController = UIStoryboard.init(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "accountController") as! AccountViewController
        let accountTabBarImage = UIImage(named: "tab_bar_account")
        let accountTabBarItem = UITabBarItem(title: "Account", image: accountTabBarImage, tag: 0)
        accountViewController.tabBarItem = accountTabBarItem
        
        viewControllers = [musicViewController, favoritesViewController, accountViewController]
    }
    
    @IBAction func dockedImageTapped(_ sender: Any) {
        guard let currentSong = MusicService.playbackController?.currentSong else { return }
        let playerViewController = UIStoryboard.init(name: "Player", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.song = currentSong
        playerViewController.transitioningDelegate = self
        playerViewController.modalPresentationStyle = .overCurrentContext
        present(playerViewController, animated: true, completion: nil)
    }
    
    private func configureViewControllers() {
        weak var weakSelf = self
        var tabBarItems = [UITabBarItem]()
        for (_, viewController) in viewControllers.enumerated() {
            guard let strongSelf = weakSelf else { return }
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
            tabBarItems.append(viewController.tabBarItem)
            strongSelf.addChild(viewController)
            strongSelf.contentView.addSubview(viewController.view)
            viewController.didMove(toParent: strongSelf)
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.view.isHidden = true
            viewController.view.constrainToBounds(otherView: contentView)
        }
        tabBar.items = tabBarItems
        if let firstViewController = viewControllers.first {
            setSelectedViewController(viewController: firstViewController)
        }
    }
    
    public func setSelectedViewController(viewController: UIViewController) {
        if viewControllers.contains(viewController) {
            if selectedViewController == nil {
                tabBar.selectedItem = viewController.tabBarItem
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.view.isHidden = false
                viewController.endAppearanceTransition()
                selectedViewController = viewController
            } else if selectedViewController != viewController {
                tabBar.selectedItem = viewController.tabBarItem
                selectedViewController?.beginAppearanceTransition(false, animated: false)
                selectedViewController?.view.isHidden = true
                selectedViewController?.endAppearanceTransition()
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.view.isHidden = false
                viewController.endAppearanceTransition()
                selectedViewController = viewController
            }
            
            if viewController is AccountViewController {
                updateView(visibility: .hidden, false)
            } else if let isPlaying =  MusicService.playbackController?.isPlaying, isPlaying == true {
                updateView(visibility: .shown, false)
            }
        }
    }
    
    public func updateView(visibility: AccessoryViewVisibility,_ animated: Bool = true) {
        if visibility != accessoryVisibility {
            accessoryVisibility = visibility
            switch visibility {
            case .hidden:
                let height = accessoryContainerView.frame.height + 45
                transitionAccessoryView(constant: -height, animated: animated)
            case .shown:
                transitionAccessoryView(constant: 0, animated: animated)
            }
        }
    }
    
    private func transitionAccessoryView(constant: CGFloat, animated: Bool) {
        if animated {
            DispatchQueue.main.async {
                self.accessoryBottomConstraint.constant = constant
                let timingParams = UISpringTimingParameters(mass: 3.0, stiffness: 1000, damping: 500, initialVelocity: CGVector.zero)
                let animator = UIViewPropertyAnimator(duration: 0.6, timingParameters: timingParams)
                animator.addAnimations {
                    self.view.layoutIfNeeded()
                }
                animator.startAnimation()
            }
        } else {
            accessoryBottomConstraint.constant = constant
            view.layoutIfNeeded()
        }
    }
    
    @objc func sessionStateDidChange() {
        analyzeSession()
    }
    
    private func analyzeSession() {
        let developerToken = Constants.AppleMusic.developerToken.rawValue
        if developerToken.count == 0 {
            presentNoDeveloperTokenAlert()
            return
        }
        
        let session = Session.current
        if session.isAuthenticated {
            setupViewControllers()
            
            if let firstViewController = viewControllers.first {
                setSelectedViewController(viewController: firstViewController)
            }
            
            if let navigationController = self.viewControllers.first as? UINavigationController {
                navigationController.popToRootViewController(animated: false)
            }
            
            dismiss(animated: true, completion: nil)
        }
        else if !session.isAuthenticated && presentedViewController == nil {
            presentAuthViewController()
        }
    }
    
    private func initMusicService() {
        MusicService.playbackController?.delegates.append(self)
    }
    
    private func presentAuthViewController() {
        DispatchQueue.main.async {
            let authViewController = UIStoryboard.init(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "authViewController") as! AuthViewController
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    private func presentNoDeveloperTokenAlert() {
        let linkString = "https://developer.apple.com/documentation/applemusicapi/getting_keys_and_creating_tokens"
        let alertController = UIAlertController(title: "Missing Developer Token", message: "You need to add a developer token to the Constants.swift file. \n\nYou can reference this site to create a new token:\n \(linkString)", preferredStyle: .actionSheet)
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(closeAction)
        let linkAction = UIAlertAction(title: "Go to link", style: .default) { (_) in
            let url = URL(string: linkString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        alertController.addAction(linkAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension AppContainerViewController: MusicPlaybackControllerDelegate {
    func playbackStarted(playbackController: MusicPlaybackController, forSong: Song) {
        if let metadata = forSong.attributes {
            DispatchQueue.main.async {
                if let url = metadata.artwork.url(forWidth: Int(self.expandedHeight)) {
                    self.albumArtworkImageView.setImage(url: url)
                }
            }
        }
        updateView(visibility: .shown, true)
    }
    
    func playbackProgressChanged(playbackController: MusicPlaybackController, forSong: Song, position: TimeInterval) {
        
    }
    
    func playbackPaused(playbackController: MusicPlaybackController) {
        
    }
    
    func playbackResumed(playbackController: MusicPlaybackController) {
        
    }
    
    func playbackStopped(playbackController: MusicPlaybackController) {
        updateView(visibility: .hidden, true)
    }
}

extension AppContainerViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PlayerPresenter()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PlayerDismisser()
    }
}

extension AppContainerViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarItems = tabBar.items else {
            return
        }
        if let index = tabBarItems.firstIndex(of: item) {
            let selectedViewController = viewControllers[index]
            setSelectedViewController(viewController: selectedViewController)
        }
    }
}
