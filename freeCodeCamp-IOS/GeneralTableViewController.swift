//
//  GeneralTableViewController.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 11/2/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SwifterSwift

private let reuseIdentifier = "Cell"

class GeneralTableViewController<T: PodcastCellBase>: UITableViewController {
    typealias tableViewCell = T
    
    var headers = [PodcastCategoryIds.javascript.readable, PodcastCategoryIds.apple.readable, PodcastCategoryIds.programming.readable]
    
    var type: PodcastTypes
    var tabTitle: String
    var tags: [Int]
    var categories: [String]
    
    // Paging Properties
    var loading = false
    let pageSize = 10
    let preloadMargin = 5
    
    var lastLoadedPage = 0
    
    var customTabBarItem: UITabBarItem! {
        get {
            switch type {
            case .new:
                return nil
            case .recommended:
                return UITabBarItem(title: L10n.tabBarJustForYou, image: #imageLiteral(resourceName: "activity_feed"), selectedImage: #imageLiteral(resourceName: "activity_feed_selected"))
            case .top:
                return UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
            }
        }
    }
    
    // ViewModelController
    private let podcastViewModelController: PodcastViewModelController = PodcastViewModelController()
    private var itemCountIsZero: Bool {
        get {
            return podcastViewModelController.viewModelsCount == 0
        }
    }
    
    init(tableViewStyle: UITableViewStyle,
         tags: [Int] = [],
         categories: [PodcastCategoryIds] = [],
         type: PodcastTypes = .new,
         tabTitle: String = "") {
        self.tabTitle = tabTitle
        self.type = type
        self.tags = tags
        self.categories = categories.flatMap { $0.rawValue }
        super.init(style: tableViewStyle)
        self.tabBarItem = self.customTabBarItem
        if tabTitle != "" {
            self.title = tabTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(tableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.rowHeight = UIView.getValueScaledByScreenHeightFor(baseValue: 144)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard self.type == .recommended else { return 1 }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if podcastViewModelController.viewModelsCount <= 0 {
            // Load initial data
            self.getData(lastIdentifier: "", nextPage: 0)
            return 6
        }
        return podcastViewModelController.viewModelsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! tableViewCell
        
        if itemCountIsZero {
            cell.setupSkeletonCell()
            return cell
        }
        
        // Configure the cell...
        if let viewModel = podcastViewModelController.viewModel(at: indexPath.row) {
            cell.viewModel = viewModel
            cell.removeSkeletonCell()
            if let lastIndexPath = self.tableView?.indexPathForLastRow {
                if let lastItem = podcastViewModelController.viewModel(at: lastIndexPath.row) {
                    self.checkPage(currentIndexPath: indexPath,
                                   lastIndexPath: lastIndexPath,
                                   lastIdentifier: lastItem.uploadDateiso8601)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = podcastViewModelController.viewModel(at: indexPath.row) {
            let vc = ArticleDetailViewController()
            vc.model = viewModel
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard self.type == .recommended else { return "" }
        if podcastViewModelController.viewModelsCount > 0 {
            return headers[section]
        }
        return "Loading..."
    }
}

extension GeneralTableViewController: ArticleDetailViewControllerDelegate {
    func modelDidChange(viewModel: PodcastViewModel) {
        self.podcastViewModelController.update(with: viewModel)
    }
}

extension GeneralTableViewController {
    // MARK: Data Getters
    func checkPage(currentIndexPath: IndexPath, lastIndexPath: IndexPath, lastIdentifier: String) {
        let nextPage: Int = Int(currentIndexPath.item / self.pageSize) + 1
        let preloadIndex = nextPage * self.pageSize - self.preloadMargin
        
        if (currentIndexPath.item >= preloadIndex && self.lastLoadedPage < nextPage) || currentIndexPath == lastIndexPath {
            // @TODO: Turn lastIdentifier into some T
            self.getData(lastIdentifier: lastIdentifier, nextPage: nextPage)
        }
    }
    
    func getData(lastIdentifier: String, nextPage: Int) {
        guard self.loading == false else { return }
        self.loading = true
        podcastViewModelController.fetchData(type: self.type.rawValue, createdAtBefore: lastIdentifier, tags: self.tags, categories: self.categories, page: nextPage, onSucces: {
            self.loading = false
            self.lastLoadedPage = nextPage
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }) { (apiError) in
            self.loading = false
            log.error(apiError)
        }
    }
}

import UIKit

//private let reuseIdentifier = "Cell"

class TopTableViewController: UITableViewController {
    typealias tableViewCell = NumberedArticleTableViewCell
    
    var type: PodcastTypes
    var tabTitle: String
    var tags: [Int]
    var categories: [String]
    
    // Paging Properties
    var loading = false
    let pageSize = 10
    let preloadMargin = 5
    
    var lastLoadedPage = 0
    
    var customTabBarItem: UITabBarItem! {
        get {
            switch type {
            case .new:
                return nil
            case .recommended:
                return UITabBarItem(title: L10n.tabBarJustForYou, image: #imageLiteral(resourceName: "activity_feed"), selectedImage: #imageLiteral(resourceName: "activity_feed_selected"))
            case .top:
                return UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
            }
        }
    }
    
    // ViewModelController
    private let podcastViewModelController: PodcastViewModelController = PodcastViewModelController()
    
    init(tableViewStyle: UITableViewStyle,
         tags: [Int] = [],
         categories: [PodcastCategoryIds] = [],
         type: PodcastTypes = .new,
         tabTitle: String = "") {
        self.tabTitle = tabTitle
        self.type = type
        self.tags = tags
        self.categories = categories.flatMap { $0.rawValue }
        super.init(style: tableViewStyle)
        self.tabBarItem = self.customTabBarItem
        if tabTitle != "" {
            self.title = tabTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(tableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.rowHeight = UIView.getValueScaledByScreenHeightFor(baseValue: 144)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if podcastViewModelController.viewModelsCount > 0 {
            //            self.skeletonCollectionView.fadeOut(duration: 0.5, completion: nil)
        }
        if podcastViewModelController.viewModelsCount <= 0 {
            // Load initial data
            self.getData(lastIdentifier: "", nextPage: 0)
        }
        return podcastViewModelController.viewModelsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! tableViewCell
        
        // Configure the cell...
        if let viewModel = podcastViewModelController.viewModel(at: indexPath.row) {
            cell.viewModel = viewModel
            cell.numberLabel.text = String(indexPath.row + 1) + "."
            if let lastIndexPath = self.tableView?.indexPathForLastRow {
                if let lastItem = podcastViewModelController.viewModel(at: lastIndexPath.row) {
                    self.checkPage(currentIndexPath: indexPath,
                                   lastIndexPath: lastIndexPath,
                                   lastIdentifier: lastItem.uploadDateiso8601)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = podcastViewModelController.viewModel(at: indexPath.row) {
            let vc = ArticleDetailViewController()
            vc.model = viewModel
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension TopTableViewController: ArticleDetailViewControllerDelegate {
    func modelDidChange(viewModel: PodcastViewModel) {
        self.podcastViewModelController.update(with: viewModel)
    }
}

extension TopTableViewController {
    // MARK: Data Getters
    func checkPage(currentIndexPath: IndexPath, lastIndexPath: IndexPath, lastIdentifier: String) {
        let nextPage: Int = Int(currentIndexPath.item / self.pageSize) + 1
        let preloadIndex = nextPage * self.pageSize - self.preloadMargin
        
        if (currentIndexPath.item >= preloadIndex && self.lastLoadedPage < nextPage) || currentIndexPath == lastIndexPath {
            // @TODO: Turn lastIdentifier into some T
            self.getData(lastIdentifier: lastIdentifier, nextPage: nextPage)
        }
    }
    
    func getData(lastIdentifier: String, nextPage: Int) {
        guard self.loading == false else { return }
        self.loading = true
        podcastViewModelController.fetchData(type: self.type.rawValue, createdAtBefore: lastIdentifier, tags: self.tags, categories: self.categories, page: nextPage, onSucces: {
            self.loading = false
            self.lastLoadedPage = nextPage
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }) { (apiError) in
            self.loading = false
            log.error(apiError)
        }
    }
}
