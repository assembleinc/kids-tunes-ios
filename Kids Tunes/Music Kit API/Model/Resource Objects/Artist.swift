//
//  Artist.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - A Resource object that represents an artist of an album where an artist can be one or more persons.
 
 https://developer.apple.com/documentation/applemusicapi/artist
*/
public typealias Artist = Resource<ArtistAttributes, ArtistRelationships>

public struct ArtistAttributes: Codable {
    /**
     The notes about the artist that appear in the iTunes Store.
    */
    public let editorialNotes: EditorialNotes?
    
    /**
     (Required) The names of the genres associated with this artist.
     */
    public let genreNames: [String]
    
    /**
     (Required) The localized name of the artist.
     */
    public let name: String
    
    /**
     (Required) The URL for sharing an artist in the iTunes Store.
     */
    public let url: URL
}

public struct ArtistRelationships: Codable {
    /**
     The albums associated with the artist. By default, albums includes identifiers only.
     Fetch limits: 25 default, 100 maximum
     */
    public let albums: Relationship<Album>
    
    /**
     The genres associated with the artist. By default, genres is not included.
     Fetch limits: None
     */
    public let genres: Relationship<Genre>?
    
    /**
     The music videos associated with the artist. By default, musicVideos is not included.
     Fetch limits: 25 default, 100 maximum
     */
    public let musicVideos: Relationship<MusicVideo>?
    
    /**
     The playlists associated with the artist. By default, playlists is not included.
     Fetch limits: 10 default, 10 maximum
     */
    public let playlists: Relationship<Playlist>?
    
    /**
     The station associated with the artist. By default, station is not included.
     Fetch limits: None (one station)
     */
    public let station: Relationship<Station>?
}
