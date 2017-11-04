//
//  ArticleDetailViewController.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 11/2/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Down

protocol ArticleDetailViewControllerDelegate {
    func modelDidChange(viewModel: PodcastViewModel)
}

class ArticleDetailViewController: UIViewController {
    var delegate: ArticleDetailViewControllerDelegate?

    var model = PodcastViewModel()
    var downView: DownView!
    
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: self.view.frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        let headerView = HeaderView(width: 375, height: 200)
        headerView.setupHeader(viewModel: self.model)
        headerView.delegate = self
        self.scrollView.addSubview(headerView)
        
        downView = try? DownView(frame: CGRect(x: 0, y: headerView.bottomLeftPoint().y, width: self.view.width, height: self.view.height), markdownString: model.markdown!) {}
        self.scrollView.insertSubview(downView!, belowSubview: headerView)
        downView!.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ArticleDetailViewController: HeaderViewDelegate {
    func modelDidChange(viewModel: PodcastViewModel) {
        self.delegate?.modelDidChange(viewModel: viewModel)
    }
}
