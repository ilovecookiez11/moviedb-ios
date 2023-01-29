//
//  ProfileViewController.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 29/01/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    let profileViewModel = ProfileViewModel()
    let darkBlue = UIColor(red: 0.01, green: 0.15, blue: 0.25, alpha: 1.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = darkBlue
        let profileViewModel = ProfileViewModel()
        setupBinders()
        profileViewModel.fetchProfile()
        
    }
    
    private func setupBinders() {
        profileViewModel.myProfile.bind{ [weak self] myProfile in
            if(myProfile != nil) {
                let profile = self?.profileViewModel.parseProfile(object: myProfile!)
                DispatchQueue.main.sync {
                    self?.nameLabel.text = profile?.name
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
