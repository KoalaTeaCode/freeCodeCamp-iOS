//
//  PodcastPageViewController.swift
//  SEDaily-IOS
//
//  Created by Keith Holliday on 7/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class PodcastPageViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    var viewControllers = [UITableViewController]()
    var barItems = [TabmanBar.Item]()
    var customTabBarItem: UITabBarItem! {
        get {
            return UITabBarItem(title: L10n.tabBarTitleLatest, image: #imageLiteral(resourceName: "mic_stand"), selectedImage: #imageLiteral(resourceName: "mic_stand_selected"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = customTabBarItem
        
        self.dataSource = self
        
        self.loadViewControllers()
        
        // configure the bar
        self.bar.style = .scrollingButtonBar
        
        self.bar.items = barItems
        
        self.reloadPages()
        
        // Set the tab bar controller first selected item here
        self.tabBarController?.selectedIndex = 0
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func loadViewControllers() {
        viewControllers = [
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    tabTitle: PodcastCategoryIds.All.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.programming],
                                                                    tabTitle: PodcastCategoryIds.programming.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.tech],
                                                                    tabTitle: PodcastCategoryIds.tech.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.web_development],
                                                                    tabTitle: PodcastCategoryIds.web_development.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.software_development],
                                                                    tabTitle: PodcastCategoryIds.software_development.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.javascript],
                                                                    tabTitle: PodcastCategoryIds.javascript.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.google],
                                                                    tabTitle: PodcastCategoryIds.google.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.startup],
                                                                    tabTitle: PodcastCategoryIds.startup.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.security],
                                                                    tabTitle: PodcastCategoryIds.security.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.docker],
                                                                    tabTitle: PodcastCategoryIds.docker.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.github],
                                                                    tabTitle: PodcastCategoryIds.github.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.api],
                                                                    tabTitle: PodcastCategoryIds.api.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.git],
                                                                    tabTitle: PodcastCategoryIds.git.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.android_app_development],
                                                                    tabTitle: PodcastCategoryIds.android_app_development.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.firebase],
                                                                    tabTitle: PodcastCategoryIds.firebase.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.push_notification],
                                                                    tabTitle: PodcastCategoryIds.push_notification.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.androiddev],
                                                                    tabTitle: PodcastCategoryIds.androiddev.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.mobile_app_development],
                                                                    tabTitle: PodcastCategoryIds.mobile_app_development.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.computer_science],
                                                                    tabTitle: PodcastCategoryIds.computer_science.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.research],
                                                                    tabTitle: PodcastCategoryIds.research.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.apple],
                                                                    tabTitle: PodcastCategoryIds.apple.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.business],
                                                                    tabTitle: PodcastCategoryIds.business.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.life_lessons],
                                                                    tabTitle: PodcastCategoryIds.life_lessons.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.data_science],
                                                                    tabTitle: PodcastCategoryIds.data_science.readable),
            GeneralTableViewController<RegularArticleTableViewCell>(tableViewStyle: .plain,
                                                                    categories: [PodcastCategoryIds.machine_learning],
                                                                    tabTitle: PodcastCategoryIds.machine_learning.readable)
        ]
        
        viewControllers.forEach { (controller) in
//            barItems.append(Item(title: controller.tabTitle))
            barItems.append(Item(title: controller.title!))
        }
    }
}
