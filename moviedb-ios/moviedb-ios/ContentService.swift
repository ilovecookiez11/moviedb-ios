//
//  ContentService.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 27/01/23.
//

import Foundation

final class ContentService {
    static let shared = ContentService()
    let APIkey = AuthService.shared.APIkey
    
    private var titleArray : [Any]?
    private var detailsTitle : [String:Any]?
    private var selectedTitle : String?
    
    private init() {
        
    }
    
    func fetchContent(contentType: String, completion: @escaping (Bool) -> (Void))  {
        var reqURL = URL(string: "")
        switch (contentType) {
            case "trending":
                reqURL = URL(string: "https://api.themoviedb.org/3/trending/all/week?api_key=" + self.APIkey)!
            break
            case "topRated":
                reqURL = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=" + self.APIkey)!
            break
            case "onTV":
                reqURL = URL(string: "https://api.themoviedb.org/3/tv/on_the_air?api_key=" + self.APIkey)!
            break
            case "airingToday":
                reqURL = URL(string: "https://api.themoviedb.org/3/tv/airing_today?api_key=" + self.APIkey)!
            break
            default:
                reqURL = URL(string: "https://api.themoviedb.org/3/trending/all/week?api_key=" + self.APIkey)!
            break
        }
        
        let task = URLSession.shared.dataTask(with: reqURL!) { data, response, error in
            if error != nil {
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                completion(false)
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                if let content = json["results"] {
                    self.titleArray = content as? [Any]
                    completion(true)
                } else {
                    completion(false)
                }
                //self.requestToken = json["request_token"] as? String
            }
        }
        task.resume()
    }
    
    func fetchTitleInfo(completion: @escaping (Bool) -> (Void))  {
        //var partialURL = "string"
        let partialURL = self.selectedTitle!
        
        var reqURL = URL(string: "https://api.themoviedb.org/3/\(partialURL)?api_key=\(self.APIkey)" )!
        
        let task = URLSession.shared.dataTask(with: reqURL) { data, response, error in
            if error != nil {
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                completion(false)
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let json = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String : Any] {
                //print("myjson = ", json["results"])
                let content = json
                //self.titleArray = content as? [Any]
                self.detailsTitle = content
                completion(true)
            }
        }
        task.resume()
    }
    
    func getTitleArray() -> [Any]? {
        guard let titleArray = self.titleArray else {
            return nil
        }
        return titleArray
    }
    
    func getTitleDetails() -> [String : Any]? {
        guard let titleDetails = self.detailsTitle else {
            return nil
        }
        return titleDetails
    }
    
    func setSelectedTitle(partialURL: String) {
        self.selectedTitle = partialURL
    }
    
}
