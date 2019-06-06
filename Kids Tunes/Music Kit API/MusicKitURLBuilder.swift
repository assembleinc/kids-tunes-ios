//
//  AMUrlBuilder.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/13/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

public struct MKURLComponent {
    // Base
    static let baseURLScheme = "https"
    static let baseURLString = "api.music.apple.com"
    static let baseURLApiVersion = "/v1"
    
    // Catalog Paths
    static let chartsPath = "v1/catalog/us/charts"
    static let searchPath = "/v1/catalog/us/search"
    static let songsPath = "/v1/catalog/us/songs"
    
    // Library Paths
    static let libraryPlaylistsPath = "/v1/me/library/playlists"
    static let librarySearchPath = "/v1/me/library/search"
    
    // Query Params
    static let genreParameter = "genre"
    static let limitParameter = "limit"
    static let offsetParameter = "offset"
    static let typesParameter = "types"
    static let termParameter = "term"
    static let idsParameter = "ids"
    static let localizationParameter = "l"
    static let includeParameter = "include"
}

public var baseUrl: URL {
    var components = URLComponents()
    
    components.scheme = MKURLComponent.baseURLScheme
    components.host = MKURLComponent.baseURLString
    
    return components.url!
}

extension URLRequest {
    /**
     Adds the Apple Music User Token to the request
     */
    public mutating func addToken() {
        let appleMusicToken = Session.current.sessionSecret(forKey: .appleMusicUserToken) ?? ""
        setValue(appleMusicToken, forHTTPHeaderField: "Music-User-Token")
    }
    
    /**
     Adds the Apple Music Developer Authentication Token to the request
     */
    public mutating func addAuthentication() {
        let auth = "Bearer \(Constants.AppleMusic.developerToken.rawValue)"
        setValue(auth, forHTTPHeaderField: "Authorization")
    }
}

public struct MKURLRequest {
    
    /**
     Returns a generic `URLRequest` for the purposes of this Framework by adding the User Token and the Developer Auth Token
     
     - parameter url: URL for the request
     - parameter httpMethod: String value for the HTTP Method (e.g "GET")
     - parameter cachePolicy: Optional Cache policy, default is useProtocolCachePolicy
     - parameter timeoutInterval: Optional timeout for request, default is 5 seconds
     
     - returns: A generic `URLRequest` with the defualt needs for this Framework
     */
    
    public func request(url: URL, httpMethod: String, _ cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData, _ timeoutInterval: TimeInterval = 5.0) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = httpMethod
        request.addToken()
        request.addAuthentication()
        return request
    }
}


