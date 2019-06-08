//
//  Relationship.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - A to-one or to-many relationship from one resource object to others.
 
 https://developer.apple.com/documentation/applemusicapi/relationship
 */
public struct Relationship<Resource: Codable>: Codable {
    /**
     One or more destination objects.
     */
    public let data: [Resource]?
    
    /**
     A URL subpath that fetches the resource as the primary object. This member is only present in responses.
     */
    public let href: String?
    
    /**
     Link to the next page of resources in the relationship. Contains the offset query parameter that specifies the next page. See Fetch Resources by Page.
     */
    public let next: String?
}
