//
//  Station.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/11/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

/**
 Apple Music API - A Resource object that represents a station.
 
 https://developer.apple.com/documentation/applemusicapi/station
 */

public typealias Station = Resource<StationAttributes, StationRelationships>

/**
 The attributes for the station.
 */
public struct StationAttributes: Codable {
    /**
     (Required) The radio station artwork.
     */
    public let artwork: Artwork
    
    /**
     The duration of the stream. This value is not emitted for 'live' or programmed stations.
     */
    public let durationInMillis: Double?
    
    /**
     The notes about the station that appear in Apple Music.
     */
    public let editorialNotes: EditorialNotes?
    
    /**
     (Required) Whether the station is a live stream.
     */
    public let isLive: Bool
    
    /**
     (Required) The localized name of the station.
     */
    public let name: String
    
    /**
     (Required) The URL for sharing a station in Apple Music.
     */
    public let url: String
}

/**
 No Relationships - Void Relationship to satisfy the protocol
 */
public struct StationRelationships: Codable { }
