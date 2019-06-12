//
//  PlayParameters.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - An object that represents play parameters for resources.
 
 https://developer.apple.com/documentation/applemusicapi/playparameters
 */
public struct PlayParameters: Codable {
    /**
     (Required) The ID of the content to use for playback.
     */
    public var id: String
    
    /**
     (Required) The kind of the content to use for playback.
    */
    public let kind: String
    
    public let catalogId: String?
}
