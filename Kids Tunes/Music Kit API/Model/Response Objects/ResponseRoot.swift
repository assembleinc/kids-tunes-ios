//
//  ResponseRoot.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/12/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

/**
 Apple Music API - The JSON root object contained in every response.
 
 https://developer.apple.com/documentation/applemusicapi/responseroot
*/

public struct ResponseRoot<T: Codable>: Codable {
    /**
    The primary data for a request or response. If data exists, this property is an array of one or more resource objects. If no data exists, this property is an empty array or null.
    */
    public let data: [T]?
    
    /**
     An array of one or more errors that occurred while executing the operation.
     */
    public let errors: [AppleMusicError]?
    
    /**
     A link to the request that generated the response data or results; not present in a request.
    */
    public let href: String?
    
    /**
     A link to the next page of data or results; contains the offset query parameter that specifies the next page. See Fetch Resources by Page.
    */
    public let next: String?
    
    /**
     The results of the operation. If there are results, the object contains contents; otherwise, it is empty or null.
    */
    public let results: T?
}
