//
//  Constants.swift
//  reDiscover
//
//  Created by Gabriel Sosa on 6/6/18.
//  Copyright © 2018 Assemble. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let sessionStatusChanged = Notification.Name("SessionStatusChanged")
}

public struct Constants {
    public enum AppleMusic : String {
         case developerToken = ""
    }
    public enum Keychain : String, Codable {
        case appleMusicUserToken
    }
}
