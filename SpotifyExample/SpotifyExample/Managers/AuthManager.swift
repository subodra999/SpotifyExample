//
//  AuthManager.swift
//  SpotifyExample
//
//  Created by Subodra Banik on 30/04/21.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private var isRefreshingToken: Bool = false
    
    struct Constants {
        static let clientID = "" // enter your client id
        static let clientSecret = "" // enter yout client secret
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20playlist-read-collaborative%20user-library-modify"
    }
    
    public var signInURL: URL? {
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    private init() {}
    
    var isSignedIn: Bool {
         return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return true
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return expirationDate <= currentDate.addingTimeInterval(fiveMinutes)
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenApiUrl) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.httpBody = components.query?.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64Token = data?.base64EncodedString() else {
            print("Something went wrong in base 64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64Token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print("Error :- \(error.localizedDescription)")
                completion(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        
        guard !isRefreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            // Refresh
            refreshAccessTokenIfNeeded { [weak self] (success) in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
            
        }
    }
    
    public func refreshAccessTokenIfNeeded(completion: ((Bool) -> Void)?) {
       
        guard !isRefreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = refreshToken else {
            return
        }
        // refresh the token
        guard let url = URL(string: Constants.tokenApiUrl) else { return }
        
        isRefreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.httpBody = components.query?.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64Token = data?.base64EncodedString() else {
            print("Something went wrong in base 64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64Token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            
            self?.isRefreshingToken = false
            
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            } catch {
                print("Error :- \(error.localizedDescription)")
                completion?(false)
            }
        }
        task.resume()
    }
    
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
}
