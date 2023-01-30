//
//  MoviesViewController.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 27/01/23.
//

import UIKit
import Kingfisher

class MoviesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let moviesViewModel = MoviesViewModel()
    
    let cellId = "cellId"
    let darkBlue = UIColor(red: 0.01, green: 0.15, blue: 0.25, alpha: 1.00)
    var titleCount = 0
    private let alertController = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies and TV"
        self.navigationItem.hidesBackButton = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        collectionView.collectionViewLayout = layout
        UINavigationBar.appearance().backgroundColor = darkBlue
        
        collectionView.backgroundColor = darkBlue
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.identifier)
        createSuitSegmentedControl()
        setupAlertButtons()
        setupBinders()
        
        moviesViewModel.fetchNewContent(contentType: "trending")
    }
    
    private func setupAlertButtons() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result : UIAlertAction) -> Void in
            //action when pressed button
        }
        let profileAction = UIAlertAction(title: "View Profile", style: .default) { (result : UIAlertAction) -> Void in
            //action when pressed button
            let profileVC = ProfileViewController()
            self.present(profileVC, animated: true)
        }
        let logoutAction = UIAlertAction(title: "Log out", style: .destructive) { (result : UIAlertAction) -> Void in
            self.logout()
        }
        alertController.addAction(profileAction)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(showAlertController))
        let favorites = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(showFavorites))
        navigationItem.rightBarButtonItems = [profile, favorites]
    }
    
    private func setupBinders() {
        moviesViewModel.myContent.bind{ [weak self] myContent in
            if(myContent != nil) {
                self?.titleCount = self?.moviesViewModel.getNumberOfTitles() ?? 0
                DispatchQueue.main.sync {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 45, left: 16, bottom: 0, right: 16)
        }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.identifier, for: indexPath) as! MovieCollectionCell
        let mymovie = self.moviesViewModel.getTitleDetailsAtIndex(index: indexPath.item)
        cell.myLabel.text = mymovie.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: mymovie.releaseDate)        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = dateFormatter.string(from: myDate ?? Date())
        
        let ratingDouble = mymovie.voteAverage.doubleValue
        let rating = String(format: "%.1f", ratingDouble)
        cell.ratingLabel.text = "★ " + rating
        cell.descriptionLabel.text = mymovie.overview
        
        let url = URL(string: "https://image.tmdb.org/t/p/w500" + mymovie.posterPath)
        let processor = RoundCornerImageProcessor(cornerRadius: 14)
        cell.myImageView.layer.cornerRadius = 14
        cell.myImageView.kf.setImage(with: url, options: [.processor(processor)])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 168, height: 360)
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mymovie = self.moviesViewModel.getTitleDetailsAtIndex(index: indexPath.item)
        let partialURL = "\(mymovie.mediaType)/\(mymovie.id)"
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        moviesViewModel.selectedTitle(partialUrl: partialURL)
        detailVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(detailVC, animated: true)
    
    }
    
    func createSuitSegmentedControl() {
        let items = ["Popular", "Top Rated", "On TV", "Airing Today"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(suitDidChange(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = darkBlue
        
        self.view.addSubview(segmentedControl)
        let guide = self.view.safeAreaLayoutGuide
        segmentedControl.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func suitDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            moviesViewModel.fetchNewContent(contentType: "trending")
            break
        case 1:
            moviesViewModel.fetchNewContent(contentType: "topRated")
            break
        case 2:
            moviesViewModel.fetchNewContent(contentType: "onTV")
            break
        case 3:
            moviesViewModel.fetchNewContent(contentType: "airingToday")
            break
        default:
            break
        }
    }
    
    @objc func logout() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showAlertController() {
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func showFavorites() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let favoritesVC = storyBoard.instantiateViewController(withIdentifier: "FavoritesVC") as! FavoritesTableViewController
        self.navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
