//
//  VideoDetailViewController.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Down

class VideoDetailViewController: UIViewController {    
    var model = VideoViewModel()
    var playerView: YouTubePlayerView = YouTubePlayerView()
    var downView: DownView!
    
    lazy var scrollView: UIScrollView = {
        return UIScrollView(frame: self.view.frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        playerView = YouTubePlayerView(width: 375, height: 195)
        playerView.loadVideoID(model.videoId)
        playerView.playerVars = [
            "playsinline": "1" as AnyObject,
            "controls": "0" as AnyObject,
            "showinfo": "0" as AnyObject
        ]
//        headerView.setupHeader(viewModel: self.model)
//        headerView.delegate = self
        self.scrollView.addSubview(playerView)
        
//        guard let markdown = model.markdown else { return }
        let markdown = model.description

        downView = try? DownView(frame: CGRect(x: 0, y: playerView.bottomLeftPoint().y, width: self.view.width, height: self.view.height), markdownString: markdown) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.downView.height = self.downView.scrollView.contentSize.height
            }
        }
        downView.scrollView.isScrollEnabled = false

        self.scrollView.addSubview(downView)
        downView.scrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -playerView.height).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//extension ArticleDetailViewController: HeaderViewDelegate {
//    func modelDidChange(viewModel: PodcastViewModel) {
//        self.delegate?.modelDidChange(viewModel: viewModel)
//    }
//}

