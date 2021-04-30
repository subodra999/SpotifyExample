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
}

enum NetworkError: Error {
    case failedToGetData
    case failedToParseData
}

final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private init() { }
    
    public func getCurrentUserProfile(completionHandler: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: URLConstants.profileUrl), type: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completionHandler(.failure(NetworkError.failedToGetData))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(model)
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
