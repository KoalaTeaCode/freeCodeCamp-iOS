//
//  ArticleDetailViewController.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 11/2/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController, UIWebViewDelegate {

    var model = PodcastViewModel()
    var webView: UIWebView!
    
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: self.view.frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        let headerView = HeaderView(width: 375, height: 200)
        headerView.setupHeader(model: model)
        self.scrollView.addSubview(headerView)

        webView = UIWebView(origin: headerView.bottomLeftPoint(), width: 375, height: 400)
        webView.loadHTMLString(model.encodedPodcastDescription, baseURL: model.postLinkURL)
        self.scrollView.addSubview(webView)
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.backgroundColor = .white
        webView.scrollView.isScrollEnabled = false
        
        webView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.height = self.webView.scrollView.contentSize.height + 60
    }
}
