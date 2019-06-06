//
//  AppleMusicError.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/12/19.
//  Copyright © 2019 Assemble. All rights reserved.
//


/**
 Apple Music API - Information about an error that occurred while processing a request.
 
 https://developer.apple.com/documentation/applemusicapi/error
 */
public struct AppleMusicError: Error, Codable {
    /**
     (Required) The code for this error. For possible values, see HTTP Status Codes.
     */
    public let code: String
    
    /**
     A long description of the problem; may be localized.
     */
    public let detail: String?
    
    /**
     (Required) A unique identifier for this occurrence of the error.
     */
    public let id: String
    
    /**
     (Required) The HTTP status code for this problem.
     */
    public let status: String
    
    /**
     (Required) A short description of the problem; may be localized.
     */
    public let title: String?
}
