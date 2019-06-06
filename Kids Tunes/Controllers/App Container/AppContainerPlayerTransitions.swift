//
//  CustomTransitions.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/16/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit

class PlayerPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to) as! PlayerViewController
        let fromViewController = transitionContext.viewController(forKey: .from) as! AppContainerViewController
        toViewController.artworkImageView.image = fromViewController.albumArtworkImageView.image
        if let startingView = fromViewController.albumArtworkContainerView {
            container.addSubview(toViewController.view)
            let rect = startingView.convert(startingView.bounds, to: container)
            let referenceView = UIView(frame: rect)
            referenceView.layer.cornerRadius = startingView.layer.cornerRadius
            toViewController.view.convertFrameTo(view: referenceView, animated: false)
            toViewController.view.layer.cornerRadius = referenceView.layer.cornerRadius * 6.0
            toViewController.view.convertFrameTo(view: container, animated: true, withDuration: 0.7) { (completed) in
                transitionContext.completeTransition(completed)
            }
        }
    }
}

class PlayerDismisser: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to) as! AppContainerViewController
        let fromViewController = transitionContext.viewController(forKey: .from) as! PlayerViewController
        if let endingView = toViewController.albumArtworkContainerView {
            container.addSubview(fromViewController.view)
            let rect = endingView.convert(endingView.bounds, to: container)
            let referenceView = UIView(frame: rect)
            referenceView.layer.cornerRadius = endingView.layer.cornerRadius * 3.0
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/6, animations: {
                    fromViewController.progressView.alpha = 0
                    fromViewController.currentDurationLabel.alpha = 0
                    fromViewController.remainingDurationLabel.alpha = 0
                    fromViewController.trackTitleLabel.alpha = 0
                    fromViewController.trackSubtitleLabel.alpha = 0
                    fromViewController.previousTrackButton.alpha = 0
                    fromViewController.playPauseButton.alpha = 0
                    fromViewController.nextTrackButton.alpha = 0
                    fromViewController.heartButton.alpha = 0
                    fromViewController.closeButton.alpha = 0
                })
                
                UIView.addKeyframe(withRelativeStartTime: 1/6, relativeDuration: 4/6, animations: {
                    fromViewController.artworkImageView.convertFrameTo(view: referenceView, animated: false, withDuration: 0.3)
                })

                UIView.addKeyframe(withRelativeStartTime: 5/6, relativeDuration: 1/6, animations: {
                    fromViewController.view.alpha = 0
                })
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
        }
    }
}

extension UIView {
    func convertFrameTo(view: UIView, animated: Bool, withDuration duration: TimeInterval? = nil, completion: ((Bool) -> Void)? = nil) {
        guard let _ = superview else {
            return
        }
        
        let xScale = view.frame.size.width / self.frame.size.width
        let yScale = view.frame.size.height / self.frame.size.height
        let x = view.frame.origin.x + (self.frame.width * xScale) * self.layer.anchorPoint.x
        let y = view.frame.origin.y + (self.frame.height * yScale) * self.layer.anchorPoint.y
        
        if let duration = duration, animated {
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 500, initialSpringVelocity: 0, options: [], animations: {
                self.layer.position = CGPoint(x: x, y: y)
                self.transform = self.transform.scaledBy(x: xScale, y: yScale)
                self.layer.cornerRadius = view.layer.cornerRadius
            }) { (complete) in
                completion?(complete)
            }
        } else {
            self.layer.position = CGPoint(x: x, y: y)
            self.transform = self.transform.scaledBy(x: xScale, y: yScale)
            self.layer.cornerRadius = view.layer.cornerRadius
        }
    }
}
