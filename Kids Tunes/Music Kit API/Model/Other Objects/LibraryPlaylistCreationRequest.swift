//
//  LibraryPlaylistCreationRequest.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/22/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

/**
 Apple Music API - A request to create a new playlist in a user's library.
 
 https://developer.apple.com/documentation/applemusicapi/libraryplaylistcreationrequest
 */

public struct LibraryPlaylistCreationRequest: Codable {
    
    /**
     (Required) A dictionary that includes strings for the name and description of the new playlist.
     */
    public let attributes: LibraryPlaylistCreationRequestAttributes
    
    init(attributes: LibraryPlaylistCreationRequestAttributes) {
        self.attributes = attributes
    }
    
}

public struct LibraryPlaylistCreationRequestAttributes: Codable {
    /**
     (Required) The name of the playlist.
     */
    public let name: String?
    
    /**
     The description of the playlist.
     */
    public let description: String?
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
