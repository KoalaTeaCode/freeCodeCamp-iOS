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
