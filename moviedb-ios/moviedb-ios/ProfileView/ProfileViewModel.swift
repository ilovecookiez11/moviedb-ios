//
//  ProfileViewModel.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 29/01/23.
//

import Foundation

final class ProfileViewModel {
    var myProfile: ObservableObject<[String: Any]?> = ObservableObject(nil)
    
    func fetchProfile() {
        AuthService.shared.fetchUserInfo(){ [weak self] success in
            self?.myProfile.value = success ? AuthService.shared.getUserInfo() : nil
            
        }
    }
    
    func parseProfile(object: [String: Any]) -> Profile {
        print("parsing profile...")
        let myProfile = object
        let avatar = myProfile["avatar"] as? [String: Any]
        let tmdbAvatar = avatar?["tmdb"] as? [String: Any]
        guard let myAvatar =  tmdbAvatar?["avatar_path"] as? String else {
            let gravatar = (avatar?["gravatar"] as? String)!
            let myAvatar = "https://www.gravatar.com/avatar/" + gravatar
            return Profile(username: myProfile["username"] as! String, avatar: myAvatar, name: myProfile["name"] as! String)
        }
        
        
        return Profile(username: myProfile["username"] as! String,
                       avatar: "https://www.themoviedb.org/t/p/w100_and_h100_face/" + myAvatar,
                       name: myProfile["name"] as! String)
    }
}
