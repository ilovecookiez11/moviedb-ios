//
//  DetailViewModel.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 29/01/23.
//

import Foundation

final class DetailViewModel {
    var myTitle: ObservableObject<[String: Any]?> = ObservableObject(nil)
    
    func fetchNewTitle() {
        ContentService.shared.fetchTitleInfo() { [weak self] success in
            self?.myTitle.value = success ? ContentService.shared.getTitleDetails() : nil
        }
    }
    
    func parseTitle (object: [String : Any]) -> Title {
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
}
