//
//  MediaType.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/10/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

public enum MediaType: String, Codable {
    case albums
    case songs
    case artists
    case playlists
    case libraryPlaylists = "library-playlists"
    case librarySongs = "library-songs"
}
