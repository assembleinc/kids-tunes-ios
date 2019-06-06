//
//  PlaylistRequest.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/20/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

let favoritesPlaylistName = "My Kids Tunes Tracks"

public struct PlaylistRequest {
    
    static public func libraryPlaylists(ids: [String], limit: String? = nil, offset: String? = nil) -> URLRequest {
        var components = URLComponents()
        components.path = MKURLComponent.libraryPlaylistsPath
        
        var queryItems = [URLQueryItem]()
        
        if let limit = limit {
            let limitQueryItem = URLQueryItem(name: MKURLComponent.limitParameter, value: limit)
            queryItems.append(limitQueryItem)
        }
        
        if let offset = offset {
            let limitQueryItem = URLQueryItem(name: MKURLComponent.offsetParameter, value: offset)
            queryItems.append(limitQueryItem)
        }
        
        if ids.count > 0 {
            let idsQueryItem = URLQueryItem(name: MKURLComponent.idsParameter, value: ids.map { $0 }.joined(separator: ","))
            queryItems.append(idsQueryItem)
        }
        
        components.queryItems = queryItems
        
        let request = MKURLRequest().request(url: components.url(relativeTo: baseUrl)!, httpMethod: HTTPMethod.GET.rawValue)
        
        return request
    }
    
    static public func libraryPlaylistByID(id: String? = nil, limit: String? = nil, offset: String? = nil) -> URLRequest {
        var components = URLComponents()
        components.path = MKURLComponent.libraryPlaylistsPath
        
        if let id = id {
            components.path.append("/\(id)")
            components.path.append("/tracks")
        }
        
        var queryItems = [URLQueryItem]()
        
        if let limit = limit {
            let limitQueryItem = URLQueryItem(name: MKURLComponent.limitParameter, value: limit)
            queryItems.append(limitQueryItem)
        }
        
        if let offset = offset {
            let limitQueryItem = URLQueryItem(name: MKURLComponent.offsetParameter, value: offset)
            queryItems.append(limitQueryItem)
        }
        
        components.queryItems = queryItems
        
        let request = MKURLRequest().request(url: components.url(relativeTo: baseUrl)!, httpMethod: HTTPMethod.GET.rawValue)
        
        return request
    }
    
    static public func addTracks(tracks: [LibraryPlaylistRequestTrack], toPlaylist: String) -> URLRequest {
        var components = URLComponents()
        components.path = MKURLComponent.libraryPlaylistsPath
        components.path.append("/\(toPlaylist)/tracks")
        
        var request = MKURLRequest().request(url: components.url(relativeTo: baseUrl)!, httpMethod: HTTPMethod.POST.rawValue)
        let body : [String: [LibraryPlaylistRequestTrack]] = ["data" : tracks]
        let data = try! JSONEncoder().encode(body)
        request.httpBody = data
        
        return request
    }
    
}
