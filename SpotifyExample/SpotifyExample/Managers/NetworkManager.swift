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
    
    //MARK:- Private
    enum HTTPMethod: String {
        case GET
        case POST
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
