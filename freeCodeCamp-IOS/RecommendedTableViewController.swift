//
//  RecommendedTableViewController.swift
//  freeCodeCamp-IOS
//
//  Created by Keith Holliday on 11/28/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RecommendedTableViewController<T: PodcastCellBase>: UITableViewController {
    typealias tableViewCell = T
    
    var headers = [
        PodcastTypes.recommended.readable,
        PodcastCategoryIds.startup.readable,
        PodcastCategoryIds.apple.readable,
        PodcastCategoryIds.programming.readable]
    
    var sections = [
        PodcastTypes.recommended.rawValue,
        PodcastCategoryIds.startup.rawValue]
    
    var tabTitle: String
    var tags: [Int]
    var categories: [String]
    
    // Paging Properties
    var loading = false
    let pageSize = 10
    let preloadMargin = 5
    var lastLoadedPage = 0
    
    var customTabBarItem: UITabBarItem! {
        return UITabBarItem(title: L10n.tabBarJustForYou, image: #imageLiteral(resourceName: "activity_feed"), selectedImage: #imageLiteral(resourceName: "activity_feed_selected"))
    }
    
    // ViewModelController
    // @TODO: Think we can override this using a getViewModelController method then share more code
    private let viewModelController: RecommendedViewModelController = RecommendedViewModelController()
    
    init(tableViewStyle: UITableViewStyle,
         tags: [Int] = [],
         categories: [PodcastCategoryIds] = [],
         type: PodcastTypes = .new,
         tabTitle: String = "") {

        self.tabTitle = tabTitle
        self.tags = tags
        self.categories = categories.flatMap { $0.rawValue }
        super.init(style: tableViewStyle)
        self.tabBarItem = self.customTabBarItem
        if tabTitle != "" {
            self.title = tabTitle
        }
        
        if viewModelController.viewModelsCount <= 0 {
            self.getData(lastIdentifier: "", nextPage: 0)
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelController
            .getModelsForGroup(group: self.sections[section]).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! tableViewCell
        
        let viewModels = viewModelController
            .getModelsForGroup(group: self.sections[indexPath.section])
        
        // Configure the cell...
        if let viewModel = viewModels[indexPath.row] {
            cell.viewModel = viewModel
            log.verbose(viewModel.isUpvoted)
            
            // Is this to check if we are paging?
            if let lastIndexPath = self.tableView?.indexPathForLastRow {
                if let lastItem = viewModels[lastIndexPath.row] {
                    self.checkPage(currentIndexPath: indexPath,
                                   lastIndexPath: lastIndexPath,
                                   lastIdentifier: lastItem.uploadDateiso8601)
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModelController.viewModel(at: indexPath.row) {
            let vc = ArticleDetailViewController()
            vc.model = viewModel
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}

extension RecommendedTableViewController: ArticleDetailViewControllerDelegate {
    func modelDidChange(viewModel: PodcastViewModel) {
        self.viewModelController.update(with: viewModel)
    }
}

extension RecommendedTableViewController {
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
        
        viewModelController.fetchData(type: PodcastTypes.recommended.rawValue,
                                      createdAtBefore: lastIdentifier,
                                      tags: self.tags,
                                      categories: self.categories,
                                      page: nextPage,
                                      onSucces: {
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

