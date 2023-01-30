//
//  LoginViewModel.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 26/01/23.
//

import Foundation

final class LoginViewModel {
    
    var error: ObservableObject<String?> = ObservableObject(nil)
    var loggedIn: ObservableObject<Bool?> = ObservableObject(nil)
    
    func login(user: String, password: String) {
        AuthService.shared.login(username: user, password: password) { [weak self] success in
            self?.error.value = success ? nil : AuthService.shared.getError()
            self?.loggedIn.value = success ? true : false
        }
    }
    
    func newRequestToken() {
        AuthService.shared.fetchRequestToken()
    }
}
