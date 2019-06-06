//
//  LibraryPlaylist.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/20/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

/**
 Apple Music API - A Resource object that represents a library playlist.
 
https://developer.apple.com/documentation/applemusicapi/libraryplaylist
 */
public typealias LibraryPlaylist = Resource<LibraryPlaylistAttributes, LibraryPlaylistRelationships>

public struct LibraryPlaylistAttributes: Codable {
    /**
     The playlist artwork.
     */
    public let artwork: Artwork?
    
    /**
     A description of the playlist.
     */
    public let description: EditorialNotes?
    
    /**
     The localized name of the album.
     */
    public let name: String?
    
    /**
     The parameters to use to play back the tracks in the playlist.
     */
    public let playParams: PlayParameters?
    
    /**
     Indicates whether the playlist can be edited.
     */
    public let canEdit: Bool?
}

public struct LibraryPlaylistRelationships: Codable {
    public let tracks: Relationship<Song>
}
