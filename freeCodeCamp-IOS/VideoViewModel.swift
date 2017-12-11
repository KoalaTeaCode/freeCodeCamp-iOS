//
//  VideoViewModel.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

public struct VideoViewModel: Codable {
    let _id: String
    let kind: String
    let videoId: String
    let publishedAtiso8601: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: [Thumbnail]
    let defaultThumbnailURL: URL?
    let channelTitle: String
    let liveBroadcastContent: String
    
    init(video: Video) {
        self._id = video._id
        self.kind = video.kind
        self.videoId = video.videoId
        self.publishedAtiso8601 = video.publishedAt
        self.channelId = video.channelId
        self.title = video.title
        self.description = video.description
        self.thumbnails = video.thumbnails
        self.defaultThumbnailURL = URL(string: video.thumbnails[1].url)
        self.channelTitle = video.channelTitle
        self.liveBroadcastContent = video.liveBroadcastContent
    }
    
    init() {
        self._id = ""
        self.kind = ""
        self.videoId = ""
        self.publishedAtiso8601 = ""
        self.channelId = ""
        self.title = ""
        self.description = ""
        self.thumbnails = []
        self.defaultThumbnailURL = nil
        self.channelTitle = ""
        self.liveBroadcastContent = ""
    }
    
    var baseModelRepresentation: Video {
        return Video(viewModel: self)
    }
}

extension VideoViewModel: Equatable {
    public static func ==(lhs: VideoViewModel, rhs: VideoViewModel) -> Bool {
        return lhs._id == rhs._id &&
            lhs.kind == rhs.kind &&
            lhs.videoId == rhs.videoId &&
            lhs.publishedAtiso8601 == rhs.publishedAtiso8601 &&
            lhs.channelId == rhs.channelId &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.thumbnails == rhs.thumbnails &&
            lhs.defaultThumbnailURL == rhs.defaultThumbnailURL &&
            lhs.channelTitle == rhs.channelTitle &&
            lhs.liveBroadcastContent == rhs.liveBroadcastContent
    }
}

extension VideoViewModel {
    func getPublishedAtAsDateWith(completion: @escaping (Date?) -> Void) {
        DispatchQueue.global().async {
            // slow calculations performed here
            let date = Date(iso8601String: self.publishedAtiso8601)
            DispatchQueue.main.async {
                completion(date)
            }
        }
    }
    
    // This is too slow for a cell collection view call
    func getPublishedAtAsDate() -> Date? {
        return Date(iso8601String: self.publishedAtiso8601)
    }
}
