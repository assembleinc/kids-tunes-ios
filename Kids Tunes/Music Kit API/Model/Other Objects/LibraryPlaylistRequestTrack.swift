//
//  LibraryPlaylistRequestTrack.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/20/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 The type of the track to be added. The possible values are
 */
public enum TrackType: String, Codable {
    case songs
    case musicVideos = "music-videos"
    case librarySongs = "library-songs"
    case libraryMusicVideos = "library-music-videos"
}


/**
 Apple Music API - An object that represents a single track when added to a library playlist in a request.
 
 https://developer.apple.com/documentation/applemusicapi/libraryplaylistrequesttrack
*/
public struct LibraryPlaylistRequestTrack: Codable {
    /**
     (Required) The name of the album the music video appears on.
     */
    public let id: String
    
    /**
     (Required) The artist’s name.
     */
    public let type: TrackType
    
    init(id: String, type: TrackType) {
        self.id = id
        self.type = type
    }
}
