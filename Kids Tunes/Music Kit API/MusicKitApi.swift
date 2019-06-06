//
//  AMAlamoFireClient.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/22/19.
//  Copyright © 2019 SAssemble. All rights reserved.
//

import Foundation
import Alamofire

public enum MusicKitApiError: Error {
    case unexpectedResponseDataError
    case searchResponseError
    case noFavoritesPlaylist
}

class MusicKitApi {
    
    // MARK: - CATALOG METHODS
    /**
     The Apple Music Catalog includes all resources available in Apple Music.
    */
    
    
    /**
     Returns a Result Type that returns an Array of Songs on success
     
     - parameter genre: The identifier for the genre to use in the chart results.
     - parameter limit: The number of resources to include per chart. The default value is 20 and the maximum value is 50.
     - parameter offset: (Optional; only appears when chart is specified) The next page or group of objects to fetch.
     
     - returns: Returns Result<[Song]>
     */
    public func chart(genre: String, limit: String? = "20", offset: String? = nil, completion: @escaping (Result<[Song]>) -> Void) {
        chart(genre: genre, limit: limit, types: [.songs], offset: offset) { (result) in
            switch result {
            case .success(let chartResponse):
                if let songs = chartResponse.songs?.first?.data {
                    completion(.success(songs))
                } else {
                    completion(.failure(MusicKitApiError.unexpectedResponseDataError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Returns a Result Type that returns a ChartResponse on success
     
     - parameter genre: The identifier for the genre to use in the chart results.
     - parameter types: An `Array` of `ChartType` (songs, albums, music videos)
     - parameter limit: The number of resources to include per chart. The default value is 20 and the maximum value is 50.
     - parameter offset: (Optional; only appears when chart is specified) The next page or group of objects to fetch.
     
     - returns: Returns Result<ChartResponse>
     */
    public func chart(genre: String, limit: String? = "20", types: [ChartType]? = [.songs], offset: String? = nil, completion: @escaping (Result<ChartResponse>) -> Void) {
        let request = ChartsRequest.byGenre(genre: genre, types: types, chart: nil, limit: limit, offset: offset)
        fetch(request: request) { (result: Result<ResponseRoot<ChartResponse>>) in
            switch result {
            case .success(let response):
                if let results = response.results {
                    completion(.success(results))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /**
     Perfroms a search request in the Apple Music catalog
     */
    public func search(term: String, completion: @escaping (Result<[Song]>) -> Void) {
        let request = SearchRequest.search(term: term, limit: "25")
        fetch(request: request) { (result: Result<ResponseRoot<SearchResults>>) in
            switch result {
            case .success(let response):
                if let songs = response.results?.songs?.data {
                    completion(.success(songs))
                } else {
                    completion(.failure(MusicKitApiError.searchResponseError))   
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - LIBRARY METHODS
    /**
     The user's iCloud Music Library contains only those resources that the user added to their personal library. For example, it contains items from Apple Music, songs purchased from iTunes Store, and imports from discs and other apps. This library may include content not found in the Apple Music Catalog.
     */
    
    
    /**
     Returns a Result Type that returns an Array of all of the User's Playlists on success
     - parameter ids: The list of playlists to be fetched. If it's an empty array then this method will return all library playlists
     
     - returns: Returns Result<[LibraryPlaylist]>
     */
    public func libraryPlaylists(ids: [String], completion: @escaping (Result<[LibraryPlaylist]>) -> Void) {
        let request = PlaylistRequest.libraryPlaylists(ids: ids)
        fetch(request: request) { (result: Result<ResponseRoot<LibraryPlaylist>>) in
            switch result {
            case .success(let response):
                if let playlists = response.data {
                    completion(.success(playlists))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Returns a Result Type that returns the User Playlist matching the ID passed in on success
     - parameter id: The playlist id
     
     - returns: Returns Result<[Song]>
     */
    public func libraryPlaylist(id: String, completion: @escaping (Result<[Song]>) -> Void) {
        let request = PlaylistRequest.libraryPlaylistByID(id: id)
        fetch(request: request) { (result: Result<ResponseRoot<Song>>) in
            switch result {
            case .success(let response):
                if let songs = response.data {
                    completion(.success(songs))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Creates a new playlist in the user library specific to this App with a name of the `favoritesPlaylistName` variable
     */
    public func createFavoritesPlaylist(completion: @escaping (Result<Bool>) -> Void) {
        var components = URLComponents()
        components.path = MKURLComponent.libraryPlaylistsPath
        
        let params: [String: Any] = [
            "attributes":[
                "name": favoritesPlaylistName
            ]
        ]
        
        Alamofire.request(components.url(relativeTo: baseUrl)!,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: defaultHeaders())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    
    /**
     Returns a Result Type that returns a success boolean
     - parameter track: LibraryPlaylistRequestTrack describring the track being added to the user's library
     - parameter playlistId: The playlist id that the track will be added to
     
     - returns: Returns Result<Bool>
     */
    public func addTrack(track: LibraryPlaylistRequestTrack, playlistId: String, completion: @escaping (Result<Bool>) -> Void) {
        var components = URLComponents()
        components.path = MKURLComponent.libraryPlaylistsPath
        components.path.append("/\(playlistId)/tracks")
        
        let track : [String : String] = [
            "id": track.id,
            "type": track.type.rawValue
        ]
        
        let params: [String: Any] = [
            "data": [track]
        ]
        
        Alamofire.request(components.url(relativeTo: baseUrl)!,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: defaultHeaders())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    
    /**
     Fetches the playlist in the user library with a name of the `favoritesPlaylistName` variable
     */
    public func favoritesPlaylist(completion: @escaping (Result<LibraryPlaylist>) -> Void) {
        let api = MusicKitApi()
        api.libraryPlaylists(ids: []) { (result) in
            switch result {
            case .success(let playlists):
                let kidzTunezPlaylists = playlists.filter { $0.attributes?.name == favoritesPlaylistName }
                if let favoritesPlaylist = kidzTunezPlaylists.first {
                    completion(.success(favoritesPlaylist))
                } else {
                    completion(.failure(MusicKitApiError.noFavoritesPlaylist))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchFavorites(completion: @escaping (Result<[Song]>) -> Void) {
        favoritesPlaylist { (result) in
            switch result {
            case .success(let playlist):
                self.libraryPlaylist(id: playlist.id, completion: { (result) in
                    switch result {
                    case .success(let songs):
                        var identifiers = [String]()
                        songs.forEach({ (song) in
                            if let attributes = song.attributes, let id = attributes.playParams?.catalogId {
                                identifiers.append(id)
                            }
                        })
                        self.songs(ids: identifiers, completion: { (result) in
                            switch result {
                            case .success(let songs):
                                let childrenSongs = self.filterChildrensSongs(songs: songs)
                                completion(.success(childrenSongs))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func filterChildrensSongs(songs: [Song]) -> [Song] {
        let childrenSongs = songs.filter({ (song) -> Bool in
            var isChildFriendlySong = false
            if let isChildSong = song.attributes?.genreNames?.contains(where: { (genreName) -> Bool in
                genreName == "Children's Music"
            }) {
                isChildFriendlySong = isChildSong
            }
            return isChildFriendlySong
        })
        return childrenSongs
    }
    
    public func addSong(song: Song, completion: ((Result<Bool>) -> Void)?) {
        let api = MusicKitApi()
        let requestTrack = LibraryPlaylistRequestTrack(id: song.id, type: .songs)
        api.favoritesPlaylist { (result) in
            switch result {
            case .success(let playlist):
                api.addTrack(track: requestTrack, playlistId: playlist.id, completion: { (result) in
                    switch result {
                    case .success(let success):
                        if success {
                            completion?(.success(true))
                        }
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                })
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func songs(ids: [String], completion: @escaping (Result<[Song]>) -> Void) {
        let request = SongsRequest.byIds(ids: ids)
        fetch(request: request) { (result: Result<ResponseRoot<Song>>) in
            switch result {
            case .success(let response):
                if let songs = response.data {
                    completion(.success(songs))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /**
     Alamofire fetch helping methods
     */
    private func fetch<T>(request: URLRequest, completion: @escaping ((Result<ResponseRoot<T>>) -> Void)) {
        fetch(request: request) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(ResponseRoot<T>.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetch(request: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        Alamofire.request(request).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    public func defaultHeaders() -> HTTPHeaders {
        let appleMusicToken = Session.current.sessionSecret(forKey: .appleMusicUserToken) ?? ""
        let auth = "Bearer \(Constants.AppleMusic.developerToken.rawValue)"
        let headers: HTTPHeaders = [
            "Music-User-Token": appleMusicToken,
            "Accept": "application/json",
            "Authorization": auth
        ]
        return headers
    }
}
