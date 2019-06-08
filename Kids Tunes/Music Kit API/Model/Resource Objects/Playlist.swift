//
//  Playlist.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - A Resource object that represents a playlist.
 
 https://developer.apple.com/documentation/applemusicapi/playlist
*/
public typealias Playlist = Resource<PlaylistAttributes, PlaylistRelationships>

public enum PlaylistType: String, Codable {
    /**
     A playlist created and shared by an Apple Music user.
    */
    case userShared = "user-shared"

    /**
     A playlist created by an Apple Music curator.
     */
    case editorial
    
    /**
     A playlist created by a non-Apple curator or brand.
     */
    case external

    /**
     A personalized playlist for an Apple Music user.
     */
    case personalMix = "personal-mix"
}

public struct PlaylistAttributes: Codable {
    /**
     The playlist artwork.
    */
    public let artwork: Artwork?
    
    /**
     The display name of the curator.
     */
    public let curatorName: String?
    
    /**
     A description of the playlist.
     */
    public let description: EditorialNotes?
    
    /**
     (Required) The date the playlist was last modified.
     */
    public let lastModifiedDate: String
    
    /**
     (Required) The localized name of the album.
     */
    public let name: String
    
    /**
     The parameters to use to play back the tracks in the playlist.
     */
    public let playParams: PlayParameters?
    
    /**
     (Required) The type of playlist. Possible values are:
     user-shared: A playlist created and shared by an Apple Music user.
     editorial: A playlist created by an Apple Music curator.
     external: A playlist created by a non-Apple curator or brand.
     personal-mix: A personalized playlist for an Apple Music user.
     Possible values: user-shared, editorial, external, personal-mix
     */
    public let playlistType: PlaylistType
    
    /**
     (Required) The URL for sharing an album in the iTunes Store.
     */
    public let url: URL
}

public struct PlaylistRelationships: Codable {
//    public let curator: Relationship<Curator>
//    public let tracks: Relationship<Track>
}
