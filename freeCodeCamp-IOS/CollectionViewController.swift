//
//  CollectionViewController.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 10/27/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import KoalaTeaFlowLayout
import KTResponsiveUI
import SwiftIcons

private let reuseIdentifier = "Cell"
private let headerIdentifier = "Header"

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(RegularArticleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(UICollectionViewCell.self,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: headerIdentifier)

        self.collectionView?.backgroundColor = .white
        // Do any additional setup after loading the view.
        let layout = KoalaTeaFlowLayout(cellWidth: UIView.getValueScaledByScreenWidthFor(baseValue: 375), cellHeight: UIView.getValueScaledByScreenHeightFor(baseValue: 144), topBottomMargin: 0, leftRightMargin: 0, cellSpacing: 0)
        self.collectionView?.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RegularArticleCell
        
        // Configure the cell
        cell.setupCell(username: "Ben Sears > The Startup", postDate: Date(), minutesLength: 4)
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

class CollectionViewHeader: UICollectionReusableView {
    var titleLabel: UILabel!
    
    override func performLayout() {
        titleLabel = UILabel(leftInset: 18, topInset: 10, width: 339, height: 16)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 14))
        self.addSubview(titleLabel)
    }
    
    func setupCell(title: String) {
        self.titleLabel.text = title
    }
}

import UIKit
import SnapKit
import KTResponsiveUI
import SDWebImage

class TopArticleCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var authorView: AuthorView!
    
    var viewModel: PodcastViewModel = PodcastViewModel() {
        willSet {
            guard newValue != self.viewModel else { return }
        }
        didSet {
            self.titleLabel.text = viewModel.podcastTitle
            self.setupImageView(imageURL: viewModel.featuredImageURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let newContentView = UIView(width: 375, height: 342)
        self.contentView.frame = newContentView.frame
        
        imageView = UIImageView(leftInset: 18,
                                topInset: 15,
                                width: 339,
                                height: 156)
        self.contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = UIView.getValueScaledByScreenHeightFor(baseValue: 2)
        
        titleLabel = UILabel(origin: imageView.bottomLeftPoint(),
                             topInset: 23,
                             width: 339,
                             height: 49)
        self.contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 20))
        titleLabel.textColor = .black
        
        descriptionLabel = UILabel(origin: titleLabel.bottomLeftPoint(),
                                   topInset: 11,
                                   width: 339,
                                   height: 16)
        self.contentView.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.font = UIFont.systemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 14))
        descriptionLabel.textColor = .lightGray
        
        authorView = AuthorView(origin: descriptionLabel.bottomLeftPoint(),
                                topInset: 20,
                                width: 339,
                                height: 32)
        self.contentView.addSubview(authorView)
        imageView.backgroundColor = .lightGray
        
        self.setupDefaultData()
    }
    
    func setupDefaultData() {
        titleLabel.text = "12 Hot Startups to Join Founded by Ex-Google Engineers"
        descriptionLabel.text = "Large tech companies like Facebook, Google, and blah blah blah"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    private func setupImageView(imageURL: URL?) {
        guard let imageURL = imageURL else {
            self.imageView.image = #imageLiteral(resourceName: "freecodecamp_logo")
            return
        }
        
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.gray)
        imageView.sd_setImage(with: imageURL)
    }
    
    func setupCell(username: String, postDate: Date, minutesLength: Int) {
        self.authorView.setupView(username: username, postDate: postDate, minutesLength: minutesLength)
    }
}

class RegularArticleCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var authorView: AuthorView!
    
    var viewModel: PodcastViewModel = PodcastViewModel() {
        willSet {
            guard newValue != self.viewModel else { return }
        }
        didSet {
            self.titleLabel.text = viewModel.podcastTitle
            self.setupImageView(imageURL: viewModel.featuredImageURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        imageView = UIImageView(origin: titleLabel.topRightPoint(),
                                leftInset: 23,
                                width: 86,
                                height: 72)
        self.contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = UIView.getValueScaledByScreenHeightFor(baseValue: 2)
        
        authorView = AuthorView(origin: descriptionLabel.bottomLeftPoint(),
                                topInset: 13,
                                width: 339,
                                height: 32)
        self.contentView.addSubview(authorView)
        imageView.backgroundColor = .lightGray
        
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
            self.imageView.image = #imageLiteral(resourceName: "freecodecamp_logo")
            return
        }
        
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.gray)
        imageView.sd_setImage(with: imageURL)
    }
    
    func setupCell(username: String, postDate: Date, minutesLength: Int) {
        self.authorView.setupView(username: username, postDate: postDate, minutesLength: minutesLength)
    }
}

class AuthorView: UIView {
    var userImageView: UIImageView!
    var usernameLabel: UILabel!
    var postDateAndMinuteLengthLabel: UILabel!
    var bookmarkButton: UIButton!
    var infoButton: UIButton!
    
    override func performLayout() {
        userImageView = UIImageView(height: 32)
        self.addSubview(userImageView)
        userImageView.cornerRadius = userImageView.height / 2
        userImageView.backgroundColor = .lightGray
        
        usernameLabel = UILabel(origin: userImageView.topRightPoint(),
                                leftInset: 8,
                                topInset: 2,
                                width: 144,
                                height: 14)
        self.addSubview(usernameLabel)
        usernameLabel.font = UIFont.systemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 12))
        
        postDateAndMinuteLengthLabel = UILabel(origin: usernameLabel.bottomLeftPoint(),
                                               topInset: 2,
                                               width: 144,
                                               height: 14)
        self.addSubview(postDateAndMinuteLengthLabel)
        postDateAndMinuteLengthLabel.font = UIFont.systemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 12))
        
        bookmarkButton = UIButton(origin: usernameLabel.topRightPoint(),
                                  leftInset: 88,
                                  topInset: 8,
                                  width: 14,
                                  height: 18)
        self.addSubview(bookmarkButton)
        bookmarkButton.setIcon(icon: FontType.fontAwesome(.bookmarkO), forState: .normal)
        bookmarkButton.setIcon(icon: FontType.fontAwesome(.bookmark), forState: .selected)
        
        infoButton = UIButton(origin: bookmarkButton.topRightPoint(),
                              leftInset: 33,
                              width: 16,
                              height: 18)
        self.addSubview(infoButton)
        infoButton.setIcon(icon: FontType.fontAwesome(.ellipsisH), forState: .normal)
    }
    
    public func setupView(username: String, postDate: Date, minutesLength: Int) {
        usernameLabel.text = username
        // @TODO: Format
        let postDateString = postDate.dateString()
        let minutesLengthString = String(minutesLength) + "min read"
        
        postDateAndMinuteLengthLabel.text = postDateString + " - " + minutesLengthString
    }
}
