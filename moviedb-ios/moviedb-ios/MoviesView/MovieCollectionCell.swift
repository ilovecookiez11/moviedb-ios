//
//  MovieCollectionCell.swift
//  moviedb-ios
//
//  Created by Alessandra Lambertini on 27/01/23.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionCell"
    
    let myImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 10
        return imageView
    }()
    
    let myLabel : UILabel = {
        let label = UILabel()
        label.text = "My Label"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "My Label"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let ratingLabel : UILabel = {
        let label = UILabel()
        label.text = "★"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "My Label"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 4
        return label
    }()
    
    let myBackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.00, green: 0.71, blue: 0.89, alpha: 1.00)
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //contentView.backgroundColor = UIColor(red: 0.00, green: 0.71, blue: 0.89, alpha: 1.00)
        //
        contentView.addSubview(myBackgroundView)
        contentView.addSubview(myImageView)
        myBackgroundView.addSubview(myLabel)
        myBackgroundView.addSubview(dateLabel)
        myBackgroundView.addSubview(ratingLabel)
        myBackgroundView.addSubview(descriptionLabel)
        /*contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myBackgroundView.frame = CGRect(x:0, y: 0 , width: contentView.frame.size.width - 4 , height: contentView.frame.size.height - 6)
        myImageView.frame = CGRect(x: 0, y: 0, width: 164, height: 210)
        myLabel.frame = CGRect(x: 5, y: myImageView.frame.height-8, width: contentView.frame.size.width-10, height: 50)
        dateLabel.frame = CGRect(x: 5, y: myImageView.frame.height + 18, width: contentView.frame.size.width-10, height: 50)
        ratingLabel.frame = CGRect(x: contentView.frame.size.width - 48, y: myImageView.frame.height + 18, width: contentView.frame.size.width-10, height: 50)
        descriptionLabel.frame = CGRect(x: 5, y: myImageView.frame.height + 60, width: contentView.frame.size.width-10, height: 80)
    }
}
