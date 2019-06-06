//
//  AccountViewController.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/30/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit

enum AccountSection: CaseIterable {
    case User
    case Marketing
    
    var title: String {
        var title = ""
        switch self {
        case .User:
            title = "Apple Music"
        case .Marketing:
            title = "Developer"
        }
        return title
    }
}

enum UserSectionCell: CaseIterable {
    case logout
}

enum MerketingSectionCell: CaseIterable {
    case visit
}

class AccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func logout() {
        MusicService.deauthenticate()
    }
    
    @objc func visitSite() {
        let assembleURL = URL(string: "https://assembleinc.com")!
        if UIApplication.shared.canOpenURL(assembleURL) {
            UIApplication.shared.open(assembleURL, options: [:], completionHandler: nil)
        }
    }
}

extension AccountViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AccountSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let accountSection = AccountSection.allCases[section]
        return accountSection.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let accountSection = AccountSection.allCases[indexPath.section]
        
        var title = ""
        var buttonTitle = ""
        switch accountSection {
        case .User:
            title = "My Account"
            buttonTitle = "Log Out"
            let buttonTableCell = tableView.dequeueReusableCell(withIdentifier: "logoutButtonCell") as! ButtonTableViewCell
            buttonTableCell.actionButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
            cell = buttonTableCell
        case .Marketing:
            title = "Assemble Inc"
            buttonTitle = "Visit Site"
            let titleButtonCell = tableView.dequeueReusableCell(withIdentifier: "TitleButtonCell") as! TitleButtonTableViewCell
            titleButtonCell.actionButton.addTarget(self, action: #selector(visitSite), for: .touchUpInside)
            titleButtonCell.titleLabel.text = title
            titleButtonCell.actionButton.setTitle(buttonTitle, for: .normal)
            cell = titleButtonCell
        }
        
        return cell
    }
}


