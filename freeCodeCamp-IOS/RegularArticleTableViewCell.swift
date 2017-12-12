//
//  RegularArticleTableViewCell.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation
import Skeleton

class RegularArticleTableViewCell: PodcastCellBase {
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
        
        titleLabel = UILabel(leftInset: 18,
                             topInset: 16,
                             width: 230,
                             height: 45)
        self.contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 16))
        titleLabel.textColor = .black
        
        descriptionLabel = UILabel(origin: titleLabel.bottomLeftPoint(),
                                   topInset: 6,
                                   width: 230,
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
        
        authorView = AuthorView(origin: descriptionLabel.bottomLeftPoint(),
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
    
    // MARK: Skeleton
    var skeletonImageView: GradientContainerView!
    var skeletonTitleLabel: GradientContainerView!
    var skeletonDescriptionLabel: GradientContainerView!
    var skeletonAuthorView: GradientContainerView!
    
    private func setupSkeletonView() {
        let newContentView = UIView(width: 375, height: 144)
        self.contentView.frame = newContentView.frame
        self.contentView.backgroundColor = .white
        self.skeletonTitleLabel = GradientContainerView(leftInset: 18,
                                                        topInset: 16,
                                                        width: 230,
                                                        height: 45)
        
        self.skeletonDescriptionLabel = GradientContainerView(origin: titleLabel.bottomLeftPoint(),
                                                              topInset: 6,
                                                              width: 230,
                                                              height: 16)
        
        self.skeletonImageView = GradientContainerView(origin: titleLabel.topRightPoint(),
                                                       leftInset: 23,
                                                       width: 86,
                                                       height: 72)
        
        self.skeletonAuthorView = GradientContainerView(origin: descriptionLabel.bottomLeftPoint(),
                                                        topInset: 13,
                                                        width: 339,
                                                        height: 32)
        
        
        self.skeletonImageView.cornerRadius = self.userImageView.cornerRadius
        self.skeletonImageView.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        self.contentView.addSubview(skeletonImageView)
        self.contentView.addSubview(skeletonTitleLabel)
        self.contentView.addSubview(skeletonDescriptionLabel)
        self.contentView.addSubview(skeletonAuthorView)
        
        let baseColor = self.skeletonImageView.backgroundColor!
        let gradients = baseColor.getGradientColors(brightenedBy: 1.07)
        self.skeletonImageView.gradientLayer.colors = gradients
        self.skeletonTitleLabel.gradientLayer.colors = gradients
        self.skeletonDescriptionLabel.gradientLayer.colors = gradients
        self.skeletonAuthorView.gradientLayer.colors = gradients
    }
    
    override func setupSkeletonCell() {
        self.setupSkeletonView()
        self.slide(to: .right)
    }
    
    override func removeSkeletonCell() {
        guard skeletonImageView != nil else { return }
        
        let duration = 0.3
        
        skeletonImageView.fadeOut(duration: duration, completion: nil)
        skeletonTitleLabel.fadeOut(duration: duration, completion: nil)
        skeletonDescriptionLabel.fadeOut(duration: duration, completion: nil)
        skeletonAuthorView.fadeOut(duration: duration, completion: nil)
    }
}

extension RegularArticleTableViewCell: GradientsOwner {
    var gradientLayers: [CAGradientLayer] {
        return [skeletonImageView.gradientLayer,
                skeletonTitleLabel.gradientLayer,
                skeletonDescriptionLabel.gradientLayer,
                skeletonAuthorView.gradientLayer
        ]
    }
}
