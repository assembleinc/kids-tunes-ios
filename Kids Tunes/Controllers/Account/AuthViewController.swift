//
//  AuthViewController.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/30/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class AuthViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = attributedText(withString: "Sign in with MUSIC", boldString: "MUSIC", font: UIFont.systemFont(ofSize: 17.0))
        signInButton.setAttributedTitle(title, for: .normal)
    }

    @IBAction func signInButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        signInButton.backgroundColor = UIColor.lightGray
        authenticate()
    }
    
    private func authenticate() {
        MusicService.authenticate { [weak self] (result) in
            switch result {
            case .success(_):
                self?.resetView()
            case .failure(let error):
                self?.handleError(error: error)
            }
        }
    }
    
    private func handleError(error: MusicServiceError) {
        switch error {
        case .authorizationRejected:
            presentServiceSetupView()
        case .userTokenError, .userTokenKeychainError:
            presentAuthenticationError()
        }
    }
    
    private func presentAuthenticationError() {
        let alertController = UIAlertController(title: "Error", message: "We are having trouble getting permission to access your  music library. Please try to login again and if you are still having issues please contact support.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let supportAction = UIAlertAction(title: "Support", style: .default) { [weak self] (_) in
            self?.composeSupportEmail()
        }
        alertController.addAction(supportAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func composeSupportEmail() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        composeVC.setToRecipients(["kidstunes@assembleinc.com"])
        composeVC.setSubject("I can't login...")
        composeVC.setMessageBody("I am getting an error while trying to login to the Kids Tunes iOS app and would love some support!", isHTML: false)

        present(composeVC, animated: true, completion: nil)
    }
    
    private func presentServiceSetupView() {
        let setupViewController = SKCloudServiceSetupViewController()
        setupViewController.delegate = self
        
        let setupOptions : [SKCloudServiceSetupOptionsKey: Any] = [
            .action: SKCloudServiceSetupAction.subscribe,
            .messageIdentifier: SKCloudServiceSetupMessageIdentifier.join
        ]
        
        setupViewController.load(options: setupOptions) { [weak self] (didSuceedLoading, error) in
            if didSuceedLoading {
                DispatchQueue.main.async {
                    self?.present(setupViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func resetView() {
        signInButton.backgroundColor = UIColor(named: "AMK-red")!
        activityIndicator.stopAnimating()
    }
    
    private func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: string.count))
        return attributedString
    }
}

extension AuthViewController: SKCloudServiceSetupViewControllerDelegate {
    
    func cloudServiceSetupViewControllerDidDismiss(_ cloudServiceSetupViewController: SKCloudServiceSetupViewController) {
        resetView()
    }
}

extension AuthViewController: MFMailComposeViewControllerDelegate {
    private func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
