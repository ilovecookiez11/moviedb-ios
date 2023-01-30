//
//  MoviesViewModel.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 27/01/23.
//

import Foundation

final class MoviesViewModel {
    var myContent: ObservableObject<[Any]?> = ObservableObject(nil)
    
    func fetchNewContent(contentType: String) {
        ContentService.shared.fetchContent(contentType: contentType) { [weak self] success in
            self?.myContent.value = success ? ContentService.shared.getTitleArray() : nil
        }
    }
    
    func getTitleDetailsAtIndex(index: Int) -> Title {
        let emptyTitle = Title(name: "", overview: "", posterPath: "", mediaType: "", releaseDate: "", runtime: "", id: 0, voteAverage: 0)
        guard let titles = self.myContent.value else {
            return emptyTitle
        }
        
        let myTitle = titles[index] as! [String : Any]
        let newTitle = parseTitle(object: myTitle)
        return newTitle
    }
    
    private func parseTitle (object: [String : Any]) -> Title {
        let myTitle = object
        var myName = ""
        var myReleaseDate = ""
        var myMediaType = ""
        var myRuntime = ""
        if (myTitle["title"] != nil) {
            myName = myTitle["title"] as! String
        } else {
            myName = myTitle["name"] as! String
        }
        if(myTitle["release_date"] != nil) {
            myReleaseDate = myTitle["release_date"] as! String
            myMediaType = "movie"
        } else {
            myReleaseDate = myTitle["first_air_date"] as! String
            myMediaType = "tv"
        }
        if(myTitle["runtime"] != nil) {
            let myInt = myTitle["runtime"] as! Int
            myRuntime = String(myInt) + " minutes"
        } else {
            myRuntime = "unknown runtime"
        }
        let newTitle = Title(name: myName,
                     overview: myTitle["overview"] as! String,
                     posterPath: myTitle["poster_path"] as! String,
                     mediaType: myMediaType,
                     releaseDate: myReleaseDate,
                     runtime: myRuntime,
                     id: myTitle["id"] as! Int,                     
                     voteAverage: myTitle["vote_average"] as! NSNumber)
        return newTitle
    }
    
    func selectedTitle(partialUrl: String) {
        ContentService.shared.setSelectedTitle(partialURL: partialUrl)
    }
    
    func getNumberOfTitles() -> Int {
        return self.myContent.value?.count ?? 0
    }
}
