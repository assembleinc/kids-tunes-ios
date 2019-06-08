//
//  MKSearchRequest.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/25/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

public enum SearchRequestType {
    case catalog
    case library
}

public struct SearchRequest {
    
    static public func search(term: String, limit: String? = nil, offset: String? = nil) -> URLRequest {
        var components = URLComponents()
        components.path = MKURLComponent.searchPath
        
        var queryItems = [URLQueryItem]()
        
        if let limit = limit {
            let limitQueryItem = URLQueryItem(name: MKURLComponent.limitParameter, value: limit)
            queryItems.append(limitQueryItem)
        }
        
        if let offset = offset {
            let limitQueryItem = URLQueryItem(name: MKURLComponent.offsetParameter, value: offset)
            queryItems.append(limitQueryItem)
        }
        
        //Need to add dynamic types
        let typeQuery = URLQueryItem(name: MKURLComponent.typesParameter, value: MediaType.songs.rawValue)
        queryItems.append(typeQuery)
        
        let termQuery = URLQueryItem(name: MKURLComponent.termParameter, value: term)
        queryItems.append(termQuery)
        
        components.queryItems = queryItems
        
        let request = MKURLRequest().request(url: components.url(relativeTo: baseUrl)!, httpMethod: HTTPMethod.GET.rawValue)
        
        return request
    }
}
