//
//  VideoTableViewCell.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Skeleton

class VideoCellBase: UITableViewCell {
    var viewModel: VideoViewModel = VideoViewModel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSkeletonCell() {}
    func removeSkeletonCell() {}
}

class VideoTableViewCell: VideoCellBase {
    private var thumbnailImageView: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    private var dateLabel: UILabel = UILabel()
    
    override var viewModel: VideoViewModel {
        willSet {
            guard newValue != self.viewModel else { return }
        }
        didSet {
            self.titleLabel.text = viewModel.title
            self.dateLabel.text = viewModel.getPublishedAtAsDate()?.dateString() ?? ""
            self.setupImageView(imageURL: viewModel.defaultThumbnailURL)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        let newContentView = UIView(width: 375, height: 286)
        self.contentView.frame = newContentView.frame
        
        thumbnailImageView = UIImageView(leftInset: 15,
                                         topInset: 15,
                                         width: 345,
                                         height: 195)
        self.contentView.addSubview(thumbnailImageView)
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        
        titleLabel = UILabel(origin: thumbnailImageView.bottomLeftPoint(),
                             topInset: 7,
                             width: 345,
                             height: 45)
        self.contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 16))
        titleLabel.textColor = .black
        
        dateLabel = UILabel(origin: titleLabel.bottomLeftPoint(),
                                   topInset: 2,
                                   width: 345,
                                   height: 16)
        self.contentView.addSubview(dateLabel)
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.systemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 12))
        dateLabel.textColor = .lightGray
        
        self.setupDefaultData()
    }
    
    func setupDefaultData() {
        titleLabel.text = "5 Ways to be a better Freelancer"
        dateLabel.text = "12/13/2017"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    private func setupImageView(imageURL: URL?) {
        guard let imageURL = imageURL else {
            self.thumbnailImageView.image = #imageLiteral(resourceName: "freecodecamp_logo")
            return
        }
        
        thumbnailImageView.sd_setShowActivityIndicatorView(true)
        thumbnailImageView.sd_setIndicatorStyle(.gray)
        thumbnailImageView.sd_setImage(with: imageURL)
    }
    
    // MARK: Skeleton
    private var skeletonImageView: GradientContainerView!
    private var skeletonTitleLabel: GradientContainerView!
    private var skeletonDateLabel: GradientContainerView!
    
    private func setupSkeletonView() {
//        let newContentView = UIView(width: 375, height: 144)
//        self.contentView.frame = newContentView.frame
        self.contentView.backgroundColor = .white
        
        self.skeletonImageView = GradientContainerView(origin: thumbnailImageView.topLeftPoint(),
                                                       width: thumbnailImageView.width,
                                                       height: thumbnailImageView.height)
        
        self.skeletonTitleLabel = GradientContainerView(origin: titleLabel.topLeftPoint(),
                                                        width: titleLabel.width,
                                                        height: titleLabel.height)
        
        self.skeletonDateLabel = GradientContainerView(origin: dateLabel.topLeftPoint(),
                                                       width: dateLabel.width,
                                                       height: dateLabel.height)
        
        
        self.skeletonImageView.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        self.contentView.addSubview(skeletonImageView)
        self.contentView.addSubview(skeletonTitleLabel)
        self.contentView.addSubview(skeletonDateLabel)
        
        let baseColor = self.skeletonImageView.backgroundColor!
        let gradients = baseColor.getGradientColors(brightenedBy: 1.07)
        self.skeletonImageView.gradientLayer.colors = gradients
        self.skeletonTitleLabel.gradientLayer.colors = gradients
        self.skeletonDateLabel.gradientLayer.colors = gradients
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
        skeletonDateLabel.fadeOut(duration: duration, completion: nil)
    }
}

extension VideoTableViewCell: GradientsOwner {
    var gradientLayers: [CAGradientLayer] {
        return [skeletonImageView.gradientLayer,
                skeletonTitleLabel.gradientLayer,
                skeletonDateLabel.gradientLayer
        ]
    }
}
