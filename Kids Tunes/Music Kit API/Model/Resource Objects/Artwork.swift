//
//  Artwork.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - An object that represents artwork.
 
 https://developer.apple.com/documentation/applemusicapi/artwork
*/
public struct Artwork: Codable {
    /**
     The average background color of the image.
    */
    public let bgColor: String?
    
    /**
     (Required) The maximum height available for the image.
     */
    public let height: Int?
    
    /**
     (Required) The maximum width available for the image.
     */
    public let width: Int?
    
    /**
     The primary text color that may be used if the background color is displayed.
     */
    public let textColor1: String?
    
    /**
     The secondary text color that may be used if the background color is displayed.
     */
    public let textColor2: String?
    
    /**
     The tertiary text color that may be used if the background color is displayed.
     */
    public let textColor3: String?
    
    /**
     The final post-tertiary text color that may be used if the background color is displayed.
     */
    public let textColor4: String?
    
    /**
     (Required) The URL to request the image asset. The image filename must be preceded by {w}x{h}, as placeholders for the width and height values as described above (for example, {w}x{h}bb.jpeg).
     */
    public let url: String
    
    public func url(forWidth requestedWidth: Int) -> URL? {
        guard var width = self.width, var height = self.height else { return nil}
        width = min(requestedWidth, width)
        height = Int(Double(width) * Double(height) / Double(width))
        let urlString = url.replacingOccurrences(of: "{w}", with: "\(width)").replacingOccurrences(of: "{h}", with: "\(height)")
        return URL(string: urlString)
    }
}
