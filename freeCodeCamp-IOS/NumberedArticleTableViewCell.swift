//
//  NumberedArticleTableViewCell.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation
import Skeleton

class NumberedArticleTableViewCell: PodcastCellBase {
    var numberLabel: UILabel!
    private var userImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var authorView: AuthorView!
    
    override var viewModel: PodcastViewModel {
        willSet {
            guard newValue != self.viewModel else { return }
        }
        didSet {
            self.titleLabel.text = viewModel.podcastTitle
            self.setupImageView(imageURL: viewModel.featuredImageURL)
            self.setupCell(username: "", postDate: viewModel.getLastUpdatedAsDate()!, minutesLength: 4)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        let newContentView = UIView(width: 375, height: 144)
        self.contentView.frame = newContentView.frame
        
        numberLabel = UILabel(leftInset: 5,
                              topInset: 16,
                              width: 42,
                              height: 59)
        self.contentView.addSubview(numberLabel)
        numberLabel.numberOfLines = 1
        numberLabel.font = UIFont.boldSystemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 50))
        numberLabel.textColor = Stylesheet.Colors.secondaryColor
        numberLabel.adjustsFontSizeToFitWidth = true
        
        let amountToAdd: CGFloat = 29.0
        
        titleLabel = UILabel(leftInset: 18 + amountToAdd,
                             topInset: 16,
                             width: 230 - amountToAdd,
                             height: 45)
        self.contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 16))
        titleLabel.textColor = .black
        
        descriptionLabel = UILabel(origin: titleLabel.bottomLeftPoint(),
                                   topInset: 6,
                                   width: 230 - amountToAdd,
                                   height: 16)
        self.contentView.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.font = UIFont.systemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 12))
        descriptionLabel.textColor = .lightGray
        
        userImageView = UIImageView(origin: titleLabel.topRightPoint(),
                                    leftInset: 23,
                                    width: 86,
                                    height: 72)
        self.contentView.addSubview(userImageView)
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.cornerRadius = UIView.getValueScaledByScreenHeightFor(baseValue: 2)
        
        authorView = AuthorView(origin: CGPoint(x: descriptionLabel.bottomLeftPoint().x - 29, y: descriptionLabel.bottomLeftPoint().y),
                                topInset: 13,
                                width: 339,
                                height: 32)
        self.contentView.addSubview(authorView)
        userImageView.backgroundColor = .lightGray
        
        self.setupDefaultData()
    }
    
    func setupDefaultData() {
        titleLabel.text = "5 Ways to be a better Freelancer"
        descriptionLabel.text = "Being a freelancer is not easy. From invoicing to finding clients to building..."
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    private func setupImageView(imageURL: URL?) {
        guard let imageURL = imageURL else {
            self.userImageView.image = #imageLiteral(resourceName: "freecodecamp_logo")
            return
        }
        
        userImageView.sd_setShowActivityIndicatorView(true)
        userImageView.sd_setIndicatorStyle(.gray)
        userImageView.sd_setImage(with: imageURL)
    }
    
    func setupCell(username: String, postDate: Date, minutesLength: Int) {
        self.authorView.setupView(username: username, postDate: postDate, minutesLength: minutesLength)
    }
}
