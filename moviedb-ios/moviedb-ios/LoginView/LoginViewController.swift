//
//  ViewController.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 26/01/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let loginViewModel = LoginViewModel()
    private let spinner = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewModel.newRequestToken()
        setupBinders()
    }
    
    private func setupBinders() {
        loginViewModel.loggedIn.bind{ [weak self] loggedIn in
            //self?.stopSpinner()
            if (loggedIn != nil && loggedIn != false) {
                self?.goToMoviesView()
            }
        }
        
        loginViewModel.error.bind { [weak self] error in
            self?.stopSpinner()
            if(error != nil) {
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = false
                    self?.errorLabel.text = error
                }
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        guard let username = usernameField.text, let password = passwordField.text else {
            return
        }
        self.view.endEditing(true)
        startSpinner()
        loginViewModel.login(user: username, password: password)
    }
    
    private func goToMoviesView() {
        //without GCD, call goes through background thread, crashing the UI
        DispatchQueue.main.sync {
            self.errorLabel.isHidden = true
            self.stopSpinner()
            let moviesVC = MoviesViewController()
            moviesVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(moviesVC, animated: true)
            //self.performSegue(withIdentifier: "LoginToMovieView", sender: nil)
        }
    }
    
    private func startSpinner() {
        // add the spinner view controller
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func stopSpinner() {
        DispatchQueue.main.async {
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }
}

