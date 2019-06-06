//
//  Song.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - A Resource object that represents a song.
 
 https://developer.apple.com/documentation/applemusicapi/song
*/

public typealias Song = Resource<SongAttributes, SongRelationships>

public struct SongAttributes: Codable {
    /**
     (Required) The name of the album the song appears on.
     */
    public let albumName: String
    
    /**
     (Required) The artist’s name.
     */
    public let artistName: String
    
    /**
     (Required) The album artwork.
     */
    public let artwork: Artwork
    
    /**
     The song’s composer.
     */
    public let composerName: String?
    
    /**
     The Recording Industry Association of America (RIAA) rating of the content. The possible values for this rating are clean and explicit. No value means no rating.
     */
    public let contentRating: String?
    
    /**
     The disc number the song appears on.
     */
    public let discNumber: Int?
    
    /**
     The duration of the song in milliseconds.
     */
    public let durationInMillis: Int?
    
    /**
     The notes about the song that appear in the iTunes Store.
     */
    public let editorialNotes: EditorialNotes?
    
    /**
     The genre names the song is associated with.
     */
    public let genreNames: [String]?
    
    /**
     The International Standard Recording Code (ISRC) for the song.
     */
    public let isrc: String?
    
    /**
     (Classical music only) The movement count of this song.
     */
    public let movementCount: Int?
    
    /**
     (Classical music only) The movement name of this song.
     */
    public let movementName: String?
    
    /**
     (Classical music only) The movement number of this song.
     */
    public let movementNumber: Int?
    
    /**
     (Required) The localized name of the song.
     */
    public let name: String
    
    /**
     The parameters to use to playback the song.
     */
    public var playParams: PlayParameters?
    
    /**
     The preview assets for the song.
     */
    public let previews: [Preview]?
    
    /**
     The release date of the song in YYYY-MM-DD format.
     */
    public let releaseDate: String?
    
    /**
     (Required) The number of the song in the album’s track list.
     */
    public let trackNumber: Int
    
    /**
     The URL for sharing a song in the iTunes Store.
     */
    public let url: String?
    
    /**
     (Classical music only) The name of the associated work.
     */
    public let workname: String?
}

public struct SongRelationships: Codable {
    /**
     The albums associated with the song. By default, albums includes identifiers only.
     Fetch limits: 10 default, 10 maximum
    */
    public let albums: Relationship<Album>
    
    /**
     The artists associated with the song. By default, artists includes identifiers only.
     Fetch limits: 10 default, 10 maximum
    */
    public let artists: Relationship<Artist>
    
    /**
     The genres associated with the song. By default, genres is not included.
     Fetch limits: None
    */
    public let genres: Relationship<Genre>?
    
    /**
     The station associated with the song. By default, station is not included.
     Fetch limits: None (one station)
     */
    public let stations: Relationship<Station>?
}

extension Song {
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.attributes?.albumName == rhs.attributes?.albumName && lhs.attributes?.name == rhs.attributes?.name
    }
}
