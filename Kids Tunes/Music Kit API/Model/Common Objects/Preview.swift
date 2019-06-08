//
//  Preview.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - An object that represents a preview for resources.
 
 https://developer.apple.com/documentation/applemusicapi/preview
 */
public struct Preview: Codable {
    /**
     The preview artwork for the associated music video.
    */
    public let artwork: Artwork?
    
    /**
     (Required) The preview URL for the content.
     */
    public let url: URL
}
