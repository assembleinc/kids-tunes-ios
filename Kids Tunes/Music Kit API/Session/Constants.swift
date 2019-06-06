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
         case developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjNIQlZCTFdaQTgifQ.eyJpYXQiOjE1NTkyNTU4MDgsImV4cCI6MTU3NDgwNzgwOCwiaXNzIjoiOUNFSEVCRkhNNyJ9.htco8-UZfd0VUoWdgYGOR8ePHFS9hwEo1hjWO5PWdsPKS0TWaXuPbAr9E8d56mwsTiyUctY_osRKf617CPoMbQ"
    }
    public enum Keychain : String, Codable {
        case appleMusicUserToken
    }
}
