//
//  PlaybackViewController.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/14/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation
import MediaPlayer
import StoreKit

public enum MusicServiceError: Error {
    case authorizationRejected
    case userTokenError
    case userTokenKeychainError
}

public class MusicService {
    internal static var playbackController : MusicPlaybackController?
    
    public static func configure() {
        guard Session.current.isAuthenticated else {
            return
        }
        
        playbackController = MusicPlaybackController()
        playbackController?.configure()
    }
    
    public static func authenticate(completion: @escaping (Result<Bool, MusicServiceError>) -> Void) {
        let authStatus = SKCloudServiceController.authorizationStatus()
        switch authStatus {
        case .authorized:
            let developerToken = Constants.AppleMusic.developerToken.rawValue
            let cloudServiceController = SKCloudServiceController()
            cloudServiceController.requestUserToken(forDeveloperToken: developerToken) { (token, error) in
                if let _ = error {
                    completion(.failure(MusicServiceError.userTokenError))
                } else if let userToken = token {
                    do {
                        try Session.current.beginSession(secrets: [.appleMusicUserToken: userToken])
                        MusicService.configure()
                        completion(.success(true))
                    } catch (_) {
                        completion(.failure(MusicServiceError.userTokenKeychainError))
                    }
                }
            }
        default:
            SKCloudServiceController.requestAuthorization { (status) in
                if status == .authorized {
                    MusicService.authenticate(completion: completion)
                } else {
                    completion(.failure(MusicServiceError.authorizationRejected))
                }
            }
        }
    }
    
    public static func deauthenticate() {
        playbackController?.stop()
        playbackController = nil
        Session.current.endSession()
    }
}

protocol MusicPlaybackControllerDelegate {
    func playbackStarted(playbackController: MusicPlaybackController, forSong: Song)
    func playbackProgressChanged(playbackController: MusicPlaybackController, forSong: Song, position: TimeInterval)
    func playbackPaused(playbackController: MusicPlaybackController)
    func playbackResumed(playbackController: MusicPlaybackController)
    func playbackStopped(playbackController: MusicPlaybackController)
}

class MusicPlaybackController {

    public var delegates : [MusicPlaybackControllerDelegate] = []
    let mediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    var songs : [Song]?
    var queuedSongs : [Song]?
    var nowPlayingSong : Song?
    var timer : Timer?

    var currentSong : Song?  {
        get {
            var currentSong : Song? = nil
            if let identifier = self.mediaPlayer.nowPlayingItem?.playbackStoreID {
                let filteredsongs = self.songs?.filter() { (song) -> Bool in
                    song.id == identifier
                }
                currentSong = filteredsongs?.first
            }
            return currentSong
        }
    }
    
    var lastSong : Song?  {
        get {
            return self.songs?.last
        }
    }
    
    var isPlaying: Bool {
        get {
            return self.mediaPlayer.playbackState == .playing
        }
    }
    
    var isPaused: Bool {
        get {
            return self.mediaPlayer.playbackState == .paused
        }
    }
    
    var repeatMode: MPMusicRepeatMode = .none {
        didSet {
            self.mediaPlayer.repeatMode = repeatMode
        }
    }
    
    func nowPlayingIdentifier() -> String? {
        let nowPlayingIdentifier = self.mediaPlayer.nowPlayingItem?.playbackStoreID
        return nowPlayingIdentifier
    }
    
    func configure() {
        mediaPlayer.repeatMode = repeatMode
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingItemDidChange), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
    }
    
    @objc func playbackProgressChanged(timer : Timer) {
        if self.mediaPlayer.playbackState == .playing,
            let currentSong = self.currentSong {
            let position = self.mediaPlayer.currentPlaybackTime
            self.delegates.forEach { (delegate) in
                delegate.playbackProgressChanged(playbackController: self, forSong: currentSong, position: position)
            }
        }
    }
    
    @objc func playbackStateDidChange() {
        switch mediaPlayer.playbackState {
        case .stopped, .interrupted, .paused:
            self.timer?.invalidate()
            self.timer = nil
            self.delegates.forEach { (delegate) in
                delegate.playbackPaused(playbackController: self)
            }
        case .playing:
            let timer = Timer(timeInterval: 1, target: self, selector: #selector(playbackProgressChanged), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            self.timer = timer
            self.delegates.forEach { (delegate) in
                delegate.playbackResumed(playbackController: self)
            }
        default:
            print("Unsupported Event")
        }
    }

    @objc func nowPlayingItemDidChange() {
        if nowPlayingSong?.id != currentSong?.id {
            if let indexOfTrack = self.queuedSongs?.firstIndex(where: { $0.id == currentSong?.id }) {
                self.queuedSongs?.remove(at: indexOfTrack)
                self.delegates.forEach { (delegate) in
                    if let currentSong = self.currentSong {
                        delegate.playbackStarted(playbackController: self, forSong: currentSong)
                    }
                }
                self.nowPlayingSong = self.currentSong
            }
            else {
                self.pause()
                self.start(songs: self.queuedSongs!, completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.stop()
                    }
                })
            }
        }
    }
    
    func start(songs: [Song], completion: @escaping ((Error?) -> Void)) {
        self.songs = songs
        self.queuedSongs = songs
        self.nowPlayingSong = nil
        var songIdentifiers = [String]()
        songs.forEach { (song) in
            songIdentifiers.append(song.id)
        }
        self.mediaPlayer.beginGeneratingPlaybackNotifications()
        self.mediaPlayer.setQueue(with: songIdentifiers)
        self.mediaPlayer.play()
        completion(nil)
    }
    
    func pause() {
        self.mediaPlayer.pause()
    }
    
    func resume() {
        self.mediaPlayer.play()
    }
    
    func nextTrack() {
        self.mediaPlayer.skipToNextItem()
    }
    
    func previousTrack() {
        self.mediaPlayer.skipToPreviousItem()
    }
    
    func stop() {
        self.mediaPlayer.stop()
        self.delegates.forEach { (delegate) in
            delegate.playbackStopped(playbackController: self)
        }
    }
}
