//
//  Chart.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/10/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

public enum ChartType: String {
    case songs = "songs"
    case albums = "albums"
    case musicVideos = "music-videos"
}

/**
 Apple Music API - A Resource object that represents a chart, or a collection of the top songs, albums, or other types of resources.
 
 https://developer.apple.com/documentation/applemusicapi/chart
*/

public struct Chart<T: Codable>: Codable {
    /**
     (Required) The chart identifier.
    */
    public let chart: String
    
    /**
     (Required) An array of the requested objects, ordered by popularity. For example, if songs were specified as the chart type in the request, the array contains Song objects.
     */
    public let data: [T]?
    
    /**
     (Required) The URL for the chart.
     */
    public let href: String?
    
    /**
     (Required) The localized name for the chart.
     */
    public let name: String?
    
    /**
     The URL for the next page.
     */
    public let next: String?
}
