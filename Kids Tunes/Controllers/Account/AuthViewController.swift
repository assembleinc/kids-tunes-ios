//
//  AuthViewController.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/30/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit
import StoreKit

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
        MusicService.authenticate { [weak self] (_) in
            self?.signInButton.backgroundColor = UIColor(named: "AMK-red")!
            self?.activityIndicator.stopAnimating()
        }
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
