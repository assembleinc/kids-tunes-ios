//
//  Album.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - A Resource object that represents an album.
 
 https://developer.apple.com/documentation/applemusicapi/album
*/
public typealias Album = Resource<AlbumAttributes, AlbumRelationships>

public struct AlbumAttributes: Codable {
    /**
     (Required) The name of the album the music video appears on.
    */
    public let albumName: String?
    
    /**
     (Required) The artist’s name.
     */
    public let artistName: String
    
    /**
     The album artwork.
     */
    public let artwork: Artwork
    
    /**
     The Recording Industry Association of America (RIAA) rating of the content. The possible values for this rating are clean and explicit. No value means no rating.
     */
    public let contentRating: String?
    
    /**
     The copyright text.
     */
    public let copyright: String
    
    /**
     The notes about the album that appear in the iTunes Store.
     */
    public let editorialNotes: EditorialNotes?
    
    /**
     (Required) The names of the genres associated with this album.
     */
    public let genreNames: [String]
    
    /**
     (Required) Indicates whether the album is complete. If true, the album is complete; otherwise, it is not. An album is complete if it contains all its tracks and songs.
     */
    public let isComplete: Bool
    
    /**
     (Required) Indicates whether the album contains a single song.
     */
    public let isSingle: Bool
    
    /**
     (Required) The localized name of the album.
     */
    public let name: String
    
    /**
     The parameters to use to play back the tracks of the album.
     */
    public let playParams: PlayParameters?
    
    /**
     (Required) The name of the record label for the album.
     */
    public let recordLabel: String
    
    /**
     (Required) The release date of the album in YYYY-MM-DD format.
     */
    public let releaseDate: String
    
    /**
     (Required) The number of tracks.
     */
    public let trackCount: Int
    
    /**
     (Required) The URL for sharing the album in the iTunes Store.
     */
    public let url: URL
    
    /**
     Required) Indicates whether the album has been delivered as Mastered for iTunes.
     */
    public let isMasteredForItunes: Bool
}

public struct AlbumRelationships: Codable {
    /**
     The artists associated with the album. By default, artists includes identifiers only.
     Fetch limits: 10 default, 10 maximum
     */
    public let artists: Relationship<Artist>
    
    /**
     The genres for the album. By default, genres is not included.
     Fetch limits: None
     */
    public let genres: Relationship<Genre>?
    
    /**
     The songs and music videos on the album. By default, tracks includes objects.
     Fetch limits: 300 default, 300 maximum
     */
    public let tracks: Relationship<Song>
}
