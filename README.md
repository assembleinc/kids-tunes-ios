# Kids Tunes With Apple MusicKit - iOS README

`kids-tunes` is a sample Apple MusicKit project that demonstrates how to integrate Apple MusicKit with your iOS, Android or web app. A fully-functional sample app is available for each platform, and includes a platform-specific README with a simple walkthrough of the main features. Please be aware that the current version of this project is Beta 1 and will continue to be updated.

This README will provide a brief overview and install steps.

Note: as of 6/3/2019 we’ve experienced periodic latency issues and sporadic errors. You may experience similar issues when working with the MusicKit API.

## Requirements

- Requires iOS 12.2.x
- Requires Swift 5
- Requires XCode 10.2
- Requires Carthage (dependency manager) - AlamoFire (network requests) - Kingfisher (manage image downloads)
- Uses Storekit
- Requires MediaPlayer

## Installation

1. Clone or download this project repo to your local system
2. From the command-line, run
   `carthage update --platform iOS --no-use-binaries`
3. Load project in Xcode
4. Update `Constants.swift` with your Developer Token (see below to generate a new one)

NOTE: While you can run using a simulator, you won't be able to access Apple Music, unless you run it on an actual device. You'll also need to have a Developer account, with a certificate and provisioning profiles.

## Apple Music Pre-Requisites

In order for the sample app to work correctly with the Apple Music APIs, you will need to generate your own **Apple Music ID** and **Apple Music Keys**. These will be tied to an existing Apple Developer account and an active Apple Music Subscription. Only one Apple Music ID is needed, and can be used across all 3 platforms. A unique Apple Music Key will be needed for each environment (Dev, Prod), but can be used across all 3 platforms. Your app will fail to run without these generated and entered into your sample app.

### Generate Apple Music ID

1. Go to your [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to Certificates, Identifiers & Profiles
3. Select Identifiers on the left
4. Hit the + to Add a new Identifier
5. Select Music IDs from the list and hit Continue
6. Follow instructions to generate your Music ID

### Generate Apple MusicKit Developer Token

1. Go to your [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to Keys
3. Hit the + to Add a new Key for each Environment you need
4. Follow instructions to generate your MusicKit Key, selecting the Music ID you generated in the previous section
5. This will be used as your Developer Token in the app

## About this app

This repository provides a starter project, called Kids Tunes, that will allow a user to listen to children's music from their personal Apple Music account. The main features allow you to:

- Sign-in with your Apple Music Subscription Account
- Pull the top songs from the children's music genre in the Apple Music catalog
- Play/Pause/Rewind/Fast Forward songs
- Mark songs as Favorites and add them to a Favorites playlist

## Platform specific documentation

Detailed documentation is available in each platform's repository.

- [iOS Project](https://github.com/assembleinc/kids-tunes-ios)
- [Android Project](https://github.com/assembleinc/kids-tunes-android)
- [React Project](https://github.com/assembleinc/kids-tunes-react)

### About the creators

This app was created by [Assemble Inc.](https://assembleinc.com) as a demonstration project for WWDC 2019.

## Want to contribute?

Feel free to submit a PR for review.

---

# iOS Key Functionality Walkthrough

## Application Features

The `kids-tunes` project has 4 main features that interact with Apple Music: Authentication, Pulling Catalog Items, Music Playback, and Playlist Management.

### Authentication

The Apple Music APIs require authentication before they can be accessed. The app will need an Apple Developer Token, and each user of the app will need to login to the Apple Music service to get their Apple Music Subscription User Token.

#### Developer Token (Bearer Token)

Your Apple Developer Token will be used as the Bearer Token for all your calls, and must be present. This should be set in your `Constants.swift` file.

#### User Token

To get the individual User Token, the user will need to authenticate with their Apple Music Subscription login. The Apple Music app needs to already be installed on the device, and will take care of authentication, after being called from the app. After the user is properly authenticated, the user token is returned and saved for use throughout the rest of the session.

Use StoreKitSDK to authenticate and get the user token:

```swift
    public static func authenticate(completion: @escaping (Result<Bool, Error>) -> Void) {
        let authStatus = SKCloudServiceController.authorizationStatus()
        switch authStatus {
            case .authorized:
            let developerToken = Constants.AppleMusic.developerToken.rawValue
            let cloudServiceController = SKCloudServiceController()
            cloudServiceController.requestUserToken(forDeveloperToken: developerToken) { (token, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let userToken = token {
                    do {
                        try Session.current.beginSession(secrets: [.appleMusicUserToken: userToken])
                        MusicService.configure()
                        completion(.success(true))
                    } catch (let error) {
                        completion(.failure(error))
                    }
                }
            }
        default:
            SKCloudServiceController.requestAuthorization { (status) in
                if status == .authorized {
                    MusicService.authenticate(completion: completion)
                }
            }
        }
    }
```

### Pulling Catalog Items

The Kids Tunes app is specifically set to only pull music from the Apple Music Catalog that is tagged with the 'children's music' genre. For the sake of this sample app, the genre is hard-coded to 'kids'.

You'll first need to set the bearer token on your call to use your Apple Developer Token, as defined above.

Helper method to create the URL request to AlamoFire

```swift
static public func byGenre(genre: String, types: [ChartType]?, chart: String?, limit: String?, offset: String?) -> URLRequest {
    var components = URLComponents()
    components.path = MKURLComponent.chartsPath

    var queryItems = [URLQueryItem]()
    let genreQueryItem = URLQueryItem(name: MKURLComponent.genreParameter, value: genre)
    queryItems.append(genreQueryItem)

    if let limit = limit {
        let limitQueryItem = URLQueryItem(name: MKURLComponent.limitParameter, value: limit)
        queryItems.append(limitQueryItem)
    }

    if let offset = offset {
        let limitQueryItem = URLQueryItem(name: MKURLComponent.offsetParameter, value: offset)
        queryItems.append(limitQueryItem)
    }

    if let types = types, types.count > 0 {
        let typesQueryItem = URLQueryItem(name: MKURLComponent.typesParameter, value: types.map { $0.rawValue }.joined(separator: ","))
        queryItems.append(typesQueryItem)
    }
    components.queryItems = queryItems

    let request = MKURLRequest().request(url: components.url(relativeTo: baseUrl)!, httpMethod: HTTPMethod.GET.rawValue)

    return request
}
```

Call to Apple Music API to get Catalog Chart by Genre. There are 2 versions of this method, we are using the one that returns an array of songs.

```swift
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
```

### Music Playback

Now that you've pulled the list of all the songs from the API, you'll want to be able to control playing the song. You'll use the native player for iOS.

Tell the player to start playing this list of songs:

```swift
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
```

NOTE: If playing a Library song (from a catalog playlist), it will have a catalogID. We have to use that catalogID, or it won't play. Otherwise, you use the id in the playParams on the song attributes. This may be fixed in subsequent Apple MediaPlayerFramework updates.

To keep the app and UI in-sync with the playing of the song, you'll want to add observers for these 2 notifications, and properly handle the updates:

```swift
NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)

NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingItemDidChange), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
```

### Playlist Management

To create a new playlist:

```swift
    public func addFavoritesPlaylist(completion: @escaping (Result<Bool>) -> Void) {
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
```

To add a song to a playlist:

```swift
public func addSong(song: Song) {
        let api = MusicKitApi()
        let requestTrack = LibraryPlaylistRequestTrack(id: song.id, type: .songs)
        api.favoritesPlaylist { (result) in
            switch result {
            case .success(let playlist):
                api.addTrack(track: requestTrack, playlistId: playlist.id, completion: { (result) in
                    switch result {
                    case .success(let success):
                        if success {
                            FavoritesManager.shared.favorites.append(song)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
    }
```

To search for a playlist:

```swift
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
```

To see more, visit [Apple MusicKit.js Documentation](https://developer.apple.com/musickit/).
