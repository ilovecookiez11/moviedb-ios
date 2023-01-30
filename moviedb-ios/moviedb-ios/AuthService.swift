//
//  AuthService.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 26/01/23.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    let APIkey = "9541e2496e6d656c4fec6e0eff17329a"
    
    private var user: User?
    private var requestToken: String?
    private var validRequestToken: String?
    private var errorMsg: String?
    private var sessionId: String?
    private var userInfo: [String: Any]?
    
    private init() {
        
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        if (self.requestToken != nil) {
            let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=" + APIkey)!
            let body = "username=\(username)&password=\(password)&request_token=\(self.requestToken!)"
            let finalBody = body.data(using: .utf8)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = finalBody
                    
            URLSession.shared.dataTask(with: request){
                (data, response, error) in
                if let error = error {
                    self.errorMsg = String(describing: error)
                    completion(false)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    let errorResponse = response as! HTTPURLResponse
                    if let mimeType = errorResponse.mimeType, mimeType == "application/json",
                       let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if (json["success"] as? Bool == false) {
                            self.errorMsg = json["status_message"] as? String
                            completion(false)
                        }
                        
                    }
                    completion(false)
                    return
                }
                if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                   let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                    let success = json["success"] as? Bool
                    self.validRequestToken = json["request_token"] as? String
                    self.newSession()
                    completion(true)
                }
            }.resume()
            self.requestToken = nil
            self.errorMsg = nil
            completion(false)
        } else {
            fetchRequestToken()
            self.errorMsg = "Token error. Try logging in again."
            completion(false)
        }
    }
    
    private func newSession() {
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=" + APIkey)!
        let body = "request_token=\(self.validRequestToken!)"
        let finalBody = body.data(using: .utf8)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
                
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let error = error {
                self.errorMsg = String(describing: error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                let errorResponse = response as! HTTPURLResponse
                if let mimeType = errorResponse.mimeType, mimeType == "application/json",
                   let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                    if (json["success"] as? Bool == false) {
                        self.errorMsg = json["status_message"] as? String
                    }
                }
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                print("json: ", json)
                self.sessionId = json["session_id"] as? String
            }
        }.resume()
        self.requestToken = nil
        self.errorMsg = nil
    }
    
    func fetchRequestToken() {
        let reqURL = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=" + APIkey)!
        let task = URLSession.shared.dataTask(with: reqURL) { data, response, error in
            if error != nil {
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                self.requestToken = json["request_token"] as? String
            }
        }
        task.resume()
    }
    
    func fetchUserInfo(completion: @escaping (Bool) -> Void) {
        let reqURL = URL(string: "https://api.themoviedb.org/3/account?api_key=\(APIkey)&session_id=\(sessionId!)")!
        let task = URLSession.shared.dataTask(with: reqURL) { data, response, error in
            if error != nil {
                completion(false)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(false)
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String:Any] {
                self.userInfo = json
                print("theJSON: ", self.userInfo)
                completion(true)
            }
        }
        task.resume()
        
    }
    
    func getRequestToken() -> String? {
        guard let reqToken = self.requestToken else {
            return nil
        }
        return reqToken
    }
    
    func getError() -> String? {
        guard let reqError = self.errorMsg else {
            return nil
        }
        return reqError
    }
    
    func getSessionID() -> String? {
        guard let sessionID = self.sessionId else {
            return nil
        }
        return sessionID
    }
    
    func getUserInfo() -> [String : Any]? {
        guard let user = self.userInfo else {
            print("get userinfo is returning nil")
            return nil
        }
        print("user: ", user)
        return user
    }
}
