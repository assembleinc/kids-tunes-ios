//
//  PlayerViewController.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/16/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, MusicPlaybackControllerDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackSubtitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var remainingDurationLabel: UILabel!
    @IBOutlet weak var previousTrackButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let song = song {
            updateView(song: song)
        }
        MusicService.playbackController?.delegates.append(self)
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lastTrackButtonTapped(_ sender: Any) {
        MusicService.playbackController?.previousTrack()
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        guard let musicPlaybackController = MusicService.playbackController else { return }
        
        if musicPlaybackController.isPaused {
            MusicService.playbackController?.resume()
        } else {
            MusicService.playbackController?.pause()
        }
    }
    
    @IBAction func nextTrackButtonTapped(_ sender: Any) {
        MusicService.playbackController?.nextTrack()
    }
    
    @IBAction func heartButtonTapped(_ sender: Any) {
        guard let currentSong = MusicService.playbackController?.currentSong else { return }

        let isFavorited = FavoritesManager.shared.favorites.contains { (song) -> Bool in
            currentSong.id == song.id
        }
        
        if !isFavorited {
            addTrackToFavorites(song: currentSong)
        }
    }
    
    @objc private func addToFavoritesFailed() {
        heartButton.setImage(UIImage(named:"heart_empty"), for: .normal)
    }
    
    private func addTrackToFavorites(song: Song) {
        heartButton.setImage(UIImage(named:"heart"), for: .normal)
        FavoritesManager.shared.addSong(song: song) { (result) in
            switch result {
            case .success(let success):
                if success {
                    FavoritesManager.shared.fetchFavorites(completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func playbackStarted(playbackController: MusicPlaybackController, forSong: Song) {
        updateView(song: forSong)
    }
    
    func updateView(song: Song) {
        if let imageUrl = song.attributes?.artwork.url(forWidth: Int(artworkImageView.frame.width)) {
            artworkImageView.setImage(url: imageUrl)
        } else {
            artworkImageView.image = nil //Set placeholder image
        }
        artworkImageView.addDropshadow()
        
        if let isPlaying = MusicService.playbackController?.isPlaying, isPlaying == true {
            playPauseButton.setImage(UIImage(named: "player_controls_pause"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "player_controls_play"), for: .normal)
        }

        let isFavorited = FavoritesManager.shared.favorites.contains { (item) -> Bool in
            item.id == song.id
        }
        
        if isFavorited {
            heartButton.setImage(UIImage(named:"heart"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named:"heart_empty"), for: .normal)
        }
        
        if let backgroundColorHex = song.attributes?.artwork.bgColor {
            view.backgroundColor = UIColor(hex: backgroundColorHex)
        }
        
        if let primaryColorHex = song.attributes?.artwork.textColor1 {
            trackTitleLabel.textColor = UIColor(hex: primaryColorHex)
        }
        
        if let secondaryColorHex = song.attributes?.artwork.textColor2 {
            let secondaryColor = UIColor(hex: secondaryColorHex)
            trackSubtitleLabel.textColor = secondaryColor
            playPauseButton.tintColor = secondaryColor
            previousTrackButton.tintColor = secondaryColor
            nextTrackButton.tintColor = secondaryColor
            progressView.tintColor = secondaryColor
        }
        
        if let thirdColorHex = song.attributes?.artwork.textColor3 {
            let thirdColor = UIColor(hex: thirdColorHex)
            progressView.backgroundColor = thirdColor
            heartButton.tintColor = thirdColor
            currentDurationLabel.textColor = thirdColor
            remainingDurationLabel.textColor = thirdColor
            closeButton.tintColor = thirdColor
        }
        
        trackTitleLabel.text = song.attributes?.name
        trackSubtitleLabel.text = song.attributes?.albumName
        if let durationMilliseconds = song.attributes?.durationInMillis {
            let seconds : TimeInterval = Double(durationMilliseconds/1000)
            remainingDurationLabel.text = "-\(timeString(time: seconds))"
        }
    }
    
    func playbackProgressChanged(playbackController: MusicPlaybackController, forSong: Song, position: TimeInterval) {
        if let totalDuration = forSong.attributes?.durationInMillis {
            let totalSeconds = Double(totalDuration/1000)
            let progress = position/totalSeconds
            let difference = totalSeconds - position
            currentDurationLabel.text = timeString(time: position)
            remainingDurationLabel.text = "-\(timeString(time: difference))"
            progressView.progress = Float(progress)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let formatted = String(format: "%02i:%02i", minutes, seconds)
        return formatted
    }
    
    func playbackPaused(playbackController: MusicPlaybackController) {
        playPauseButton.setImage(UIImage(named: "player_controls_play"), for: .normal)
    }
    
    func playbackResumed(playbackController: MusicPlaybackController) {
        playPauseButton.setImage(UIImage(named: "player_controls_pause"), for: .normal)
    }
    
    func playbackStopped(playbackController: MusicPlaybackController) {
        playPauseButton.setImage(UIImage(named: "player_controls_pause"), for: .normal)
    }
}
