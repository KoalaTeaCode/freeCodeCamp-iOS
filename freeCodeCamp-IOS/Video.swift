//
//  Video.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/9/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

enum ThumbnailType: String {
    case def = "default"
    case medium = "medium"
    case high = "high"
}

public struct Thumbnail: Codable {
    var type: String?
    let url: String
    let width: Int
    let height: Int
}

extension Thumbnail: Equatable {
    public static func ==(lhs: Thumbnail, rhs: Thumbnail) -> Bool {
        return lhs.type == rhs.type &&
        lhs.url == rhs.url &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height
    }
}

public struct Video: Codable {
    let _id: String
    let kind: String
    let videoId: String
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: [Thumbnail]
    let channelTitle: String
    let liveBroadcastContent: String
    
    init(_id: String,
        kind: String,
        videoId: String,
        publishedAt: String,
        channelId: String,
        title: String,
        description: String,
        thumbnails: [Thumbnail],
        channelTitle: String,
        liveBroadcastContent: String) {
        self._id = _id
        self.kind = kind
        self.videoId = videoId
        self.publishedAt = publishedAt
        self.channelId = channelId
        self.title = title
        self.description = description
        self.thumbnails = thumbnails
        self.channelTitle = channelTitle
        self.liveBroadcastContent = liveBroadcastContent
    }
    
    enum CodingKeys: String, CodingKey { // declaring our keys
        case _id
        case kind
        case videoId
        case publishedAt
        case channelId
        case title
        case description
        case thumbnails
        case channelTitle
        case liveBroadcastContent
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
        
        let _id: String = try container.decode(String.self, forKey: ._id)
        let kind: String = try container.decode(String.self, forKey: .kind)
        let videoId: String = try container.decode(String.self, forKey: .videoId)
        let publishedAt: String = try container.decode(String.self, forKey: .publishedAt)
        let channelId: String = try container.decode(String.self, forKey: .channelId)
        let title: String = try container.decode(String.self, forKey: .title)
        let description: String = try container.decode(String.self, forKey: .description)
        let channelTitle: String = try container.decode(String.self, forKey: .channelTitle)
        let liveBroadcastContent: String = try container.decode(String.self, forKey: .liveBroadcastContent)
        
        var thumbnails: [Thumbnail] = []
        
        // Decode JSON into dictionary
        let thumbnailDictionary: [String: Thumbnail] = try container.decode([String: Thumbnail].self, forKey: .thumbnails)
        // Add key to value as Thumbnail
        for (key, var thumbnail) in thumbnailDictionary {
            thumbnail.type = key
            // Add adjusted thumbnail to empty thumbnails array
            thumbnails.append(thumbnail)
        }
        
        self.init(_id: _id,
                  kind: kind,
                  videoId: videoId,
                  publishedAt: publishedAt,
                  channelId: channelId,
                  title: title,
                  description: description,
                  thumbnails: thumbnails,
                  channelTitle: channelTitle,
                  liveBroadcastContent: liveBroadcastContent)
    }
}

extension Video {
    func getPublishedAtDateWith(completion: @escaping (Date?) -> Void) {
        DispatchQueue.global().async {
            // slow calculations performed here
            let date = Date(iso8601String: self.publishedAt)
            DispatchQueue.main.async {
                completion(date)
            }
        }
    }
    
    func getPublishedAtDate() -> Date? {
        return Date(iso8601String: self.publishedAt)
    }
}

extension Video: Equatable {
    public static func ==(lhs: Video, rhs: Video) -> Bool {
        return lhs._id == rhs._id &&
            lhs.kind == rhs.kind &&
            lhs.videoId == rhs.videoId &&
            lhs.publishedAt == rhs.publishedAt &&
            lhs.channelId == rhs.channelId &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.thumbnails == rhs.thumbnails &&
            lhs.channelTitle == rhs.channelTitle &&
            lhs.liveBroadcastContent == rhs.liveBroadcastContent
    }
}

extension Video {
    init(viewModel: VideoViewModel) {
        self._id = viewModel._id
        self.kind = viewModel.kind
        self.videoId = viewModel.videoId
        self.publishedAt = viewModel.publishedAtiso8601
        self.channelId = viewModel.channelId
        self.title = viewModel.title
        self.description = viewModel.description
        self.thumbnails = viewModel.thumbnails
        self.channelTitle = viewModel.channelTitle
        self.liveBroadcastContent = viewModel.liveBroadcastContent
    }
}


