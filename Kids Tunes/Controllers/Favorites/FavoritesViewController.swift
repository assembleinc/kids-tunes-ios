//
//  FavoritesViewController.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 6/3/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import StoreKit
import UIKit

class FavoritesViewController: UIViewController, MusicPlaybackControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerContainer: UIView!
    
    var favorites = FavoritesManager.shared.favorites
    
    var nowPlayingIndexPath: IndexPath? {
        didSet(oldValue) {
            DispatchQueue.main.async {
                if let oldIndex = oldValue, let oldCell = self.tableView.cellForRow(at: oldIndex) as? TrackTableViewCell {
                    oldCell.trackTitleLabel.textColor = UIColor(named: "AMK-dark-blue")
                    oldCell.pauseButton.isHidden = true
                }
                
                if let indexPath = self.nowPlayingIndexPath {
                    self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        DispatchQueue.main.async {
                            if let newCell = self.tableView.cellForRow(at: indexPath) as? TrackTableViewCell {
                                newCell.trackTitleLabel.textColor = UIColor(named: "AMK-red")
                                newCell.pauseButton.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    var headerView: TrackListTableHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicService.playbackController?.delegates.append(self)

        let headerView = Bundle.main.loadNibNamed("TrackListTableHeader", owner: self, options: nil)?.first as! TrackListTableHeader
        headerContainer.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.constrainToBounds(otherView: headerContainer)
        
        headerView.titleLabel.text = "Favorites"
        headerView.playButton.addTarget(self, action: #selector(headerPlayButtonTapped), for: .touchUpInside)
        headerView.shuffleButton.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
        self.headerView = headerView
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))

        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: FavoritesManager.favoritesUpdated, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFavorites()
        updateHeaderView()
        configureNowPlayingCell()
    }
    
    func fetchFavorites() {
        activityIndicator.startAnimating()
        FavoritesManager.shared.fetchFavorites { [weak self] (result) in
            switch result {
            case .success(let favorites):
                self?.favorites = favorites
            case .failure(let error as MusicKitApiError):
                if error == MusicKitApiError.noFavoritesPlaylist {
                    FavoritesManager.shared.createFavoritesPlaylist(completion: nil)
                }
            case .failure(let error):
                print(error)
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
    @objc private func favoritesUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func headerPlayButtonTapped() {
        MusicService.playbackController?.start(songs: favorites,  completion: { (error) in
            //Show playback error
        })
    }
    
    @objc private func headerPauseButtonTapped() {
        MusicService.playbackController?.pause()
    }
    
    @objc private func shuffleButtonTapped() {
        let shuffledSongs = favorites.shuffled()
        MusicService.playbackController?.start(songs: shuffledSongs, completion: { (error) in
            //Show playback error
        })
    }
    
    
    private func updateCurrentIndex(songId: String) {
        let index = favorites.firstIndex { (song) -> Bool in
            song.id == songId
        }
        if let index = index {
            nowPlayingIndexPath = IndexPath(row: index, section: 0)
        } else {
            nowPlayingIndexPath = nil
        }
    }
    
    private func updateHeaderView() {
        guard let playbackController = MusicService.playbackController else { return }
        let isPlaying = playbackController.isPlaying
        switch isPlaying {
        case true:
            headerView.playButton.setImage(UIImage(named: "pause"), for: .normal)
            headerView.playButton.removeTarget(self, action: #selector(headerPlayButtonTapped), for: .touchUpInside)
            headerView.playButton.addTarget(self, action: #selector(headerPauseButtonTapped), for: .touchUpInside)
            headerView.playButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        case false:
            headerView.playButton.setImage(UIImage(named: "play"), for: .normal)
            headerView.playButton.removeTarget(self, action: #selector(headerPauseButtonTapped), for: .touchUpInside)
            headerView.playButton.addTarget(self, action: #selector(headerPlayButtonTapped), for: .touchUpInside)
            headerView.playButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 4, right: 0)
        }
    }
    
    private func configureNowPlayingCell() {
        guard let playbackController = MusicService.playbackController else { return }
        guard let nowplayingIndex = nowPlayingIndexPath else { return }
        guard let nowPlayingCell = tableView.cellForRow(at: nowplayingIndex) as? TrackTableViewCell else { return }
        
        let isPlaying = playbackController.isPlaying
        switch isPlaying {
        case true:
            nowPlayingCell.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            nowPlayingCell.pauseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case false:
            nowPlayingCell.pauseButton.setImage(UIImage(named: "play"), for: .normal)
            nowPlayingCell.pauseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        }
    }
    
    // MARK: - MusicPlaybackControllerDelegate
    func playbackStarted(playbackController: MusicPlaybackController, forSong: Song) {
        updateCurrentIndex(songId: forSong.id)
        updateHeaderView()
        configureNowPlayingCell()
    }
    
    func playbackProgressChanged(playbackController: MusicPlaybackController, forSong: Song, position: TimeInterval) {
        
    }
    
    func playbackPaused(playbackController: MusicPlaybackController) {
        updateHeaderView()
        configureNowPlayingCell()
    }
    
    func playbackResumed(playbackController: MusicPlaybackController) {
        updateHeaderView()
        configureNowPlayingCell()
    }
    
    func playbackStopped(playbackController: MusicPlaybackController) {
        nowPlayingIndexPath = nil
        updateHeaderView()
        configureNowPlayingCell()
    }
}


// MARK: - Table View

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesManager.shared.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell") as! TrackTableViewCell
        let item = FavoritesManager.shared.favorites[indexPath.row]
        cell.trackTitleLabel.text = item.attributes?.name
        cell.trackSubtitleLabel.text = item.attributes?.artistName
        cell.contentContainerButton.addDropshadow()
        
        if let url = item.attributes?.artwork.url(forWidth: 200) {
            cell.artworkImageView.setImage(url: url)
        }
        
        if let nowPlayingIndexPath = nowPlayingIndexPath, nowPlayingIndexPath == indexPath {
            cell.pauseButton.isHidden = false
            cell.trackTitleLabel.textColor = UIColor(named: "AMK-red")
        }

        let isFavorited = FavoritesManager.shared.favorites.contains { (song) -> Bool in
            item.id == song.id
        }
        cell.favoritedImageView.isHidden = !isFavorited
        
        cell.delegate = self
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let slicedTracks = Array(favorites[indexPath.row...(favorites.count - 1)])
        MusicService.playbackController?.start(songs: slicedTracks, completion: { (error) in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.setSelected(false, animated: true)
        })
    }
}

extension FavoritesViewController: TrackTableViewCellDelegate {
    func didSelectPauseButton(cell: UITableViewCell) {
        guard let playbackController = MusicService.playbackController,
            let indexPath = tableView.indexPath(for: cell),
            let cell = tableView.cellForRow(at: indexPath) as? TrackTableViewCell else {
                return
        }
        
        let isPlaying = playbackController.isPlaying
        switch isPlaying {
        case true:
            cell.pauseButton.setImage(UIImage(named: "play"), for: .normal)
            cell.pauseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            MusicService.playbackController?.pause()
        case false:
            cell.pauseButton.setImage(UIImage(named: "pause_small"), for: .normal)
            cell.pauseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            MusicService.playbackController?.resume()
        }
    }
}
