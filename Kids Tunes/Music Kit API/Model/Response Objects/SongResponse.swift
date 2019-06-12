//
//  SongResponse.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/25/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

/**
 Apple Music API - The response to a song request.
 
 https://developer.apple.com/documentation/applemusicapi/songresponse
 */

public struct SongResponse: Codable {
    /**
     (Required) The data included in the response for a song object request.
     */
    public let data: [Song]?
}
