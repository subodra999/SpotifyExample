//
//  NetworkManager.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/04/21.
//

import Foundation

struct URLConstants {
    static let base = "https://api.spotify.com/v1"
    static let profileUrl = base + "/me"
    static let newReleasesUrl = base + "/browse/new-releases?limit=50"
    static let featuredPlaylist = base + "/browse/featured-playlists?limit=20"
    static let recommendedGenres = base + "/recommendations/available-genre-seeds"
    static func recommendations(seeds: String) -> String {
        return base + "/recommendations?limit=40&seed_genres=\(seeds)"
    }
    static func albumDetails(id: String) -> String {
        return base + "/albums/\(id)"
    }
    static func playlistDetails(id: String) -> String {
        return base + "/playlists/\(id)"
    }
    static let categories = base + "/browse/categories"
    static func categoryPlaylist(id: String) -> String {
        return base + "/browse/categories/\(id)/playlists"
    }
    static func searchQuery(with query: String) -> String {
        return base + "/search?limit=20&type=album,artist,track,playlist&q=\(query)"
    }
    static let userPlaylists = base + "/me/playlists/?limit=50"
    static func createPlaylist(with id: String) -> String {
        return base + "/users/\(id)/playlists"
    }
    static func addTrackToPlaylist(id: String) -> String {
        return base + "/playlists/\(id)/tracks"
    }
    static func removeTrackFromPlaylist(id: String) -> String {
        return base + "/playlists/\(id)/tracks"
    }
    static let userAlbums = base + "/me/albums"
    static func saveAlbum(id: String) -> String {
        return base + "/me/albums/?ids=\(id)"
    }
}

enum NetworkError: Error {
    case failedToGetData
    case failedToParseData
}

final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private init() { }
    
    //MARK: - Album
    
    public func getAlbumDetails(for album: Album, completionHandler: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.albumDetails(id: album.id ?? "")), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Playlist
    
    public func getPlaylistDetails(for playlist: Playlist, completionHandler: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.playlistDetails(id: playlist.id ?? "")), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Profile
    
    public func getCurrentUserProfile(completionHandler: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.profileUrl), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(UserProfile.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Browse
    
    public func getNewReleases(completionHandler: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.newReleasesUrl), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completionHandler: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.featuredPlaylist), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completionHandler: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.recommendedGenres), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>, completionHandler: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: URLConstants.recommendations(seeds: seeds)), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    //MARK:- Category
    
    public func getCategories(completionHandler: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.categories), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completionHandler(.success(model.categories?.items ?? []))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(category: Category, completionHandler: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.categoryPlaylist(id: category.id ?? "")), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completionHandler(.success(model.playlists?.items ?? []))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    //MARK:- Search
    
    public func search(with query: String, completionHandler: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.searchQuery(with: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(SearchResultsResponse.self, from: data)
                    
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: model.albums?.items?.compactMap { SearchResult.album(model: $0) } ?? [])
                    searchResults.append(contentsOf: model.tracks?.items?.compactMap { SearchResult.track(model: $0) } ?? [])
                    searchResults.append(contentsOf: model.artists?.items?.compactMap { SearchResult.artist(model: $0) } ?? [])
                    searchResults.append(contentsOf: model.playlists?.items?.compactMap { SearchResult.playlist(model: $0) } ?? [])
                    
                    completionHandler(.success(searchResults))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    //MARK:- Library
    
    public func getCurrentUserPlaylists(completionHandler: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.userPlaylists), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(PlaylistsResponse.self, from: data)
                    completionHandler(.success(model.items ?? []))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    public func createPlaylist(with name: String, completionHandler: @escaping (Bool) -> Void) {
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.createRequest(with: URL(string: URLConstants.createPlaylist(with: profile.id ?? "")), type: .POST, completion: { baseRequest in
                    var request = baseRequest
                    let json = [
                        "name": name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                        guard let data = data, error == nil else {
                            completionHandler(false)
                            return
                        }
                        do {
                            let model = try JSONDecoder().decode(Playlist.self, from: data)
                            print("created: \(model)")
                            completionHandler(true)
                        } catch {
                            completionHandler(false)
                        }
                    }
                    task.resume()
                })
            case .failure(_):
                completionHandler(false)
            }
        }
    }
    
    public func addTrackToPlaylist(track: AudioTrack, playlist: Playlist, completionHandler: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: URLConstants.addTrackToPlaylist(id: playlist.id ?? "")), type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": [
                    "spotify:track:\(track.id ?? "")"
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any], (response["snapshot_id"] as? String) != nil {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                } catch {
                    completionHandler(false)
                }
            }
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completionHandler: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: URLConstants.removeTrackFromPlaylist(id: playlist.id ?? "")), type: .DELETE) { baseRequest in
            var request = baseRequest
            let json = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id ?? "")"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any], (response["snapshot_id"] as? String) != nil {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                } catch {
                    completionHandler(false)
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserAlbums(completionHandler: @escaping (Result<[Album], Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.userAlbums), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                    completionHandler(.success(model.items?.compactMap { $0.album } ?? []))
                } catch {
                    completionHandler(.failure(NetworkError.failedToParseData))
                }
            }
            task.resume()
        }
    }
    
    public func saveAlbum(album: Album, completionHandler: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: URLConstants.saveAlbum(id: album.id ?? "")), type: .PUT) { (baseRequest) in
            var request = baseRequest
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: baseRequest) { (_, response, error) in
                guard let code = (response as? HTTPURLResponse)?.statusCode, error == nil else {
                    completionHandler(false)
                    return
                }
                completionHandler(code == 200 || code == 201)
            }
            task.resume()
        }
    }
    
    //MARK:- Private
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        AuthManager.shared.withValidToken { (token) in
            guard let apiUrl = url else { return }
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
