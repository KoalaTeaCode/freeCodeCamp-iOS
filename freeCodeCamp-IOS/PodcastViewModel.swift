//
//  PodcastViewModel.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 10/21/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

public struct PodcastViewModel: Codable {
    let _id: String
    var podcastTitle: String
    let encodedPodcastDescription: String
    let summary: String?
    let markdown: String?
    let uploadDateiso8601: String
    let postLinkURL: URL?
    let postAuthor: String
    let categories: [String]?
    var categoriesAsString: String {
        get {
            guard let categories = self.categories else { return "" }
            let stringArray = categories.map { String(describing: $0) }
            return stringArray.joined(separator: " ")
        }
    }
    let featuredImageURL: URL?
    
    var totalFavorites: Int
    var score: Int
    var isUpvoted: Bool = false
    var isDownvoted: Bool = false
    
    init(podcast: Podcast) {
        self._id = podcast._id
        self.podcastTitle = podcast.title
        self.encodedPodcastDescription = podcast.description
        self.summary = nil
        self.markdown = podcast.markdown
        self.uploadDateiso8601 = podcast.date
        self.postLinkURL = URL(string: podcast.link)
        self.postAuthor = podcast.author
        self.categories = podcast.categories
        self.featuredImageURL = URL(string: podcast.featuredImage ?? "")
        self.totalFavorites = podcast.totalFavorites
        self.score = podcast.score
        if let upvoted = podcast.upvoted {
            self.isUpvoted = upvoted
        }
        if let downvoted = podcast.downvoted {
            self.isDownvoted = downvoted
        }
    }
    
    init() {
        self._id = ""
        self.uploadDateiso8601 = ""
        self.postLinkURL = nil
        self.categories = []
        self.featuredImageURL = nil
        self.podcastTitle = ""
        self.encodedPodcastDescription = ""
        self.summary = nil
        self.markdown = nil
        self.score = 0
        self.totalFavorites = 0
        self.postAuthor = ""
    }
}

extension PodcastViewModel: Equatable {
    public static func ==(lhs: PodcastViewModel, rhs: PodcastViewModel) -> Bool {
        return lhs._id == rhs._id &&
            lhs.uploadDateiso8601 == rhs.uploadDateiso8601 &&
            lhs.postLinkURL == rhs.postLinkURL &&
            lhs.categories ?? [] == rhs.categories ?? [] &&
            lhs.featuredImageURL == rhs.featuredImageURL &&
            lhs.encodedPodcastDescription == rhs.encodedPodcastDescription &&
            lhs.score == rhs.score
    }
}

extension PodcastViewModel {
    func getLastUpdatedAsDateWith(completion: @escaping (Date?) -> Void) {
        DispatchQueue.global().async {
            // slow calculations performed here
            let date = Date(iso8601String: self.uploadDateiso8601)
            DispatchQueue.main.async {
                completion(date)
            }
        }
    }
    
    // This is too slow for a cell collection view call
    func getLastUpdatedAsDate() -> Date? {
        return Date(iso8601String: self.uploadDateiso8601)
    }
}

extension PodcastViewModel {
    func getHTMLDecodedDescription(completion: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            // slow calculations performed here
            let decodedString = self.encodedPodcastDescription.htmlDecodedWithSomeEntities ?? ""
            DispatchQueue.main.async {
                completion(decodedString)
            }
        }
    }
    func getHTMLDecodedAttributedString(completion: @escaping (NSMutableAttributedString?) -> Void) {
        DispatchQueue.global().async {
            // slow calculations performed here
            let decodedString = self.encodedPodcastDescription.htmlDecodedAsAttributedString
            DispatchQueue.main.async {
                completion(NSMutableAttributedString(attributedString: decodedString!))
            }
        }
    }
}
