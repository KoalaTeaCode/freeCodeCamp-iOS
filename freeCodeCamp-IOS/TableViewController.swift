//
//  TableViewController.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 10/31/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Skeleton

private let reuseIdentifier = "Cell"

class TableViewController: UITableViewController {

    var headers: [String] = ["New From Network", "JavaScript"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(RegularArticleTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.rowHeight = UIView.getValueScaledByScreenHeightFor(baseValue: 144)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RegularArticleTableViewCell

        // Configure the cell...
        cell.setupCell(username: "Ben Sears > The Startup", postDate: Date(), minutesLength: 4)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = headers[section]
        let view = UITableViewHeaderFooterView(width: 375, height: 34)
        view.contentView.backgroundColor = .white
        view.textLabel?.text = headerTitle
        return view
    }
}

class PodcastCellBase: UITableViewCell {
    var viewModel: PodcastViewModel = PodcastViewModel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSkeletonCell() {}
    func removeSkeletonCell() {}
}

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
            self.setupCell(username: viewModel.postAuthor, postDate: viewModel.getLastUpdatedAsDate()!, minutesLength: 4)
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
            self.setupCell(username: viewModel.postAuthor, postDate: viewModel.getLastUpdatedAsDate()!, minutesLength: 4)
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

