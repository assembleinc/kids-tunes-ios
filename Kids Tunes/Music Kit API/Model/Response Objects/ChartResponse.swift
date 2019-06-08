//
//  ChartResponse.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/12/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

/**
 Apple Music API - The response to a chart request.
 
 https://developer.apple.com/documentation/applemusicapi/chartresponse
*/

public struct ChartResponse: Codable {
    /**
     The albums returned when fetching charts.
    */
    public let albums: [Chart<Album>]?
    
    /**
     The music videos returned when fetching charts.
    */
    public let musicVideos: [Chart<MusicVideo>]?
    
    /**
     The songs returned when fetching charts.
    */
    public let songs: [Chart<Song>]?
}
