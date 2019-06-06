//
//  FavoritesManager.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/30/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation
import Alamofire

class FavoritesManager {
    static let favoritesUpdated = Notification.Name("FavoritesUpdated")
    static let shared = FavoritesManager()
    
    var favorites = [Song]() {
        didSet {
            NotificationCenter.default.post(name: FavoritesManager.favoritesUpdated, object: nil)
        }
    }
    
    public func fetchFavorites(completion: ((Result<[Song]>) -> Void)?) {
        let api = MusicKitApi()
        api.fetchFavorites { (result) in
            switch result {
            case .success(let favorites):
                FavoritesManager.shared.favorites = favorites
                completion?(.success(favorites))
            case .failure(let error):
                FavoritesManager.shared.favorites = [Song]()
                completion?(.failure(error))
            }
        }
    }
    
    public func createFavoritesPlaylist(completion: ((Bool) -> Void)?) {
        let api = MusicKitApi()
        api.createFavoritesPlaylist { (result) in
            switch result {
            case .success(let success):
                if success {
                    completion?(true)
                } else {
                    completion?(false)
                }
            case .failure((_)):
                completion?(false)
            }
        }
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
}
