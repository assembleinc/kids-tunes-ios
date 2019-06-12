//
//  LibraryPlaylistResponse.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/20/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

/**
The response to a library playlist request.
 
https://developer.apple.com/documentation/applemusicapi/libraryplaylistresponse
 */

public struct LibraryPlaylistResponse: Codable {
    /**
     (Required) The data included in the response for a library playlist object 
     */
    public let data: [LibraryPlaylist]?
}
