//
//  MKSongsRequest.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/30/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

public struct SongsRequest {
    
    static public func byIds(ids: [String]) -> URLRequest {
        var components = URLComponents()
        components.path = MKURLComponent.songsPath
        
        var queryItems = [URLQueryItem]()
        let genreQueryItem = URLQueryItem(name: MKURLComponent.localizationParameter, value: "en-US")
        queryItems.append(genreQueryItem)
        
        if ids.count > 0 {
            let idsQueryItem = URLQueryItem(name: MKURLComponent.idsParameter, value: ids.map { $0 }.joined(separator: ","))
            queryItems.append(idsQueryItem)
        }
        components.queryItems = queryItems
        
        let request = MKURLRequest().request(url: components.url(relativeTo: baseUrl)!, httpMethod: HTTPMethod.GET.rawValue)
        
        return request
    }
    
    static public func librarySongsByIds(ids: [String]) -> URLRequest {
        var components = URLComponents()
        components.path = MKURLComponent.songsPath
        
        var queryItems = [URLQueryItem]()
        let genreQueryItem = URLQueryItem(name: MKURLComponent.localizationParameter, value: "en-US")
        queryItems.append(genreQueryItem)
        
        if ids.count > 0 {
            let idsQueryItem = URLQueryItem(name: MKURLComponent.idsParameter, value: ids.map { $0 }.joined(separator: ","))
            queryItems.append(idsQueryItem)
        }
        components.queryItems = queryItems
        
        let request = MKURLRequest().request(url: components.url(relativeTo: baseUrl)!, httpMethod: HTTPMethod.GET.rawValue)
        
        return request
    }
}
