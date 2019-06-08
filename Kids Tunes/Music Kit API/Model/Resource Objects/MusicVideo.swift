//
//  MusicVideo.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - A Resource object that represents a music video.
 
 https://developer.apple.com/documentation/applemusicapi/musicvideo
*/
public typealias MusicVideo = Resource<MusicVideoAttributes, MusicVideoRelationships>

public struct MusicVideoAttributes: Codable {
    /**
     The name of the album the music video appears on.
    */
    public let albumName: String?
    
    /**
     (Required) The artist’s name.
     */
    public let artistName: String
    
    /**
     (Required) The artwork for the music video’s associated album.
     */
    public let artwork: Artwork
    
    /**
     The Recording Industry Association of America (RIAA) rating of the content. The possible values for this rating are clean and explicit. No value means no rating.
     */
    public let contentRating: String?
    
    /**
     The duration of the music video in milliseconds.
     */
    public let durationInMillis: Int?
    
    /**
     The editorial notes for the music video.
     */
    public let editorialNotes: EditorialNotes?
    
    /**
     (Required) The music video’s associated genres.
     */
    public let genreNames: [String]
    
    /**
     (Required) The International Standard Recording Code (ISRC) for the music video.
     */
    public let isrc: String
    
    /**
     (Required) The localized name of the music video.
     */
    public let name: String
    
    /**
     The parameters to use to play back the music video.
     */
    public let playParams: PlayParameters?
    
    /**
     (Required) The preview assets for the music video.
     */
    public let previews: [Preview]
    
    /**
     (Required) The release date of the music video in YYYY-MM-DD format.
     */
    public let releaseDate: String
    
    /**
     The number of the music video in the album’s track list.
     */
    public let trackNumber: Int?
    
    /**
     (Required) A URL for sharing the music video.
     */
    public let url: URL
    
    /**
     The video subtype associated with the content.
     */
    public let videoSubType: String?
    
    /**
     (Required) Whether the music video has HDR10-encoded content.
     */
    public let hasHDR: Bool
    
    /**
     (Required) Whether the music video has 4K content.
     */
    public let has4k: Bool
}

public struct MusicVideoRelationships: Codable {
    /**
     The albums associated with the music video. By default, albums includes identifiers only.
     Fetch limits: 10 default, 10 maximum
    */
    public let albums: Relationship<Album>
    
    /**
     The artists associated with the music video. By default, artists includes identifiers only.
     Fetch limits: 10 default, 10 maximum
     */
    public let artists: Relationship<Artist>
    
    /**
     The genres associated with the music video. By default, genres is not included.
     Fetch limits: None
     */
    public let genres: Relationship<Genre>?
}
