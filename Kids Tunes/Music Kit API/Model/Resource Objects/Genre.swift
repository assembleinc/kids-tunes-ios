//
//  Genre.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - An object that represents a genre for resources.
 
 https://developer.apple.com/documentation/applemusicapi/genre
*/
public typealias Genre = Resource<GenreAttributes, GenreRelationships>

public struct GenreAttributes: Codable {
    /**
     (Required) The localized name of the genre.
    */
    public let name: String
}

/**
 No Relationships - Void Relationship to satisfy the protocol
 */
public struct GenreRelationships: Codable { }
