//
//  SkeletonCollectionView.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 10/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import KoalaTeaFlowLayout
private let reuseIdentifier = "Cell"

class SkeletonCollectionView: UIView, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        
        self.collectionView!.register(PodcastCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let layout = KoalaTeaFlowLayout(cellWidth: UIView.getValueScaledByScreenWidthFor(baseValue: 158),
                                        cellHeight: UIView.getValueScaledByScreenHeightFor(baseValue: 250),
                                        topBottomMargin: UIView.getValueScaledByScreenHeightFor(baseValue: 12),
                                        leftRightMargin: UIView.getValueScaledByScreenWidthFor(baseValue: 20),
                                        cellSpacing: UIView.getValueScaledByScreenWidthFor(baseValue: 8))
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PodcastCell
        
        // Configure the cell
        cell.setupSkeletonCell()

        return cell
    }
}

class SkeletonTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    var tableViewStyle: UITableViewStyle = .plain
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let newFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let newFrame = frame
        self.frame = newFrame
        self.tableView = UITableView(frame: newFrame, style: self.tableViewStyle)
        self.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(RegularArticleTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.rowHeight = UIView.getValueScaledByScreenHeightFor(baseValue: 144)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RegularArticleTableViewCell
        
        // Configure the cell
        cell.setupSkeletonCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableViewStyle {
        case .grouped:
            return "test"
        case .plain:
            return ""
        }
    }
}
