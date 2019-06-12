//
//  Resource.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

/**
 Apple Music API - A resource—such as an album, song, or playlist—in the Apple Music catalog or iCloud Music Library.
 
 https://developer.apple.com/documentation/applemusicapi/resource
*/
public struct Resource<Attributes: Codable, Relationships: Codable>: Codable {
    /**
     Attributes belonging to the resource (can be a subset of the attributes). The members are the names of the attributes defined in the object model.
     */
    public var attributes: Attributes?
    
    /**
     A URL subpath that fetches the resource as the primary object. This member is only present in responses.
     */
    public let href: String?
    
    /**
     (Required) Persistent identifier of the resource.
     */
    public let id: String
    
    /**
     Relationships belonging to the resource (can be a subset of the relationships). The members are the names of the relationships defined in the object model. See Relationship object for the values of the members.
     */
    public let relationships: Relationships?
    
    /**
     (Required) The type of resource.
     */
    public let type: MediaType
}
