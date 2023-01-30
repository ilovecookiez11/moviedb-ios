//
//  DetailViewController.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 29/01/23.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    let detailViewModel = DetailViewModel()
    let darkBlue = UIColor(red: 0.01, green: 0.15, blue: 0.25, alpha: 1.00)
    var myMediaTitle = ""
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var runningTimeLabel: UILabel!
    
    @IBOutlet weak var myDescriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailViewModel.fetchNewTitle()
        view.backgroundColor = darkBlue
        setupBinders()
    }
    @IBAction func favoriteTitle(_ sender: Any) {
        let defaults = UserDefaults.standard
        var array = defaults.object(forKey:"Favorites") as? [String] ?? [String]()
        if (!array.contains(myMediaTitle)) {
            array.append(myMediaTitle)
        }
        defaults.set(array, forKey: "Favorites")
    }
    
    private func setupBinders() {
        detailViewModel.myTitle.bind{ [weak self] myTitle in
            if(myTitle != nil) {
                let title = self?.detailViewModel.parseTitle(object: myTitle!)
                DispatchQueue.main.sync {
                    let url = URL(string: "https://image.tmdb.org/t/p/w500" + title!.posterPath)
                    let processor = RoundCornerImageProcessor(cornerRadius: 14)
                    self?.posterImage.layer.cornerRadius = 14
                    self?.posterImage.kf.setImage(with: url, options: [.processor(processor)])
                    self?.titleLabel.text = title?.name
                    self?.myMediaTitle = title!.name
                    
                    let ratingDouble = title?.voteAverage.doubleValue
                    let rating = String(format: "%.1f", ratingDouble!)
                    self?.scoreLabel.text = "★ " + rating
                    
                    self?.myDescriptionText.text = title?.overview
                    
                    self?.mediaLabel.text = title?.mediaType
                    
                    self?.runningTimeLabel.text = title?.runtime
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let myDate = dateFormatter.date(from: title!.releaseDate)
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateStyle = .medium
                    self?.yearLabel.text = dateFormatter.string(from: myDate ?? Date())
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
