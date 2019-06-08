//
//  EditorialNotes.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - An object that represents notes.
 
 https://developer.apple.com/documentation/applemusicapi/editorialnotes
 */
public struct EditorialNotes: Codable {
    /**
     Notes shown when the content is prominently displayed.
     */
    public let standard: String?
    
    /**
     Abbreviated notes shown inline or when the content is shown alongside other content.
    */
    public let short: String?
}
