//
//  SearchResults.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/25/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

public struct SearchResults: Codable {
    
    /**
     The songs returned when fetching charts.
     */
    public let songs: SongResponse?
}
