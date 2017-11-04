//
//  Podcast.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 10/12/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

enum PodcastTypes: String {
    case new = "new"
    case top = "top"
    case recommended = "recommended"
}

enum PodcastCategoryIds: String {
    case All = "All"
    case programming = "programming"
    case tech = "tech"
    case web_development = "web-development"
    case software_development = "software-development"
    case javascript = "javascript"
    case google = "google"
    case startup = "startup"
    case security = "security"
    case docker = "docker"
    case github = "github"
    case api = "api"
    case git = "git"
    case android_app_development = "android-app-development"
    case firebase = "firebase"
    case push_notification = "push-notification"
    case androiddev = "androiddev"
    case mobile_app_development = "mobile-app-development"
    case computer_science = "computer-science"
    case research = "research"
    case apple = "apple"
    case business = "business"
    case life_lessons = "life-lessons"
    case data_science = "data-science"
    case machine_learning = "machine-learning"
    
    private var description: String {
        switch self {
        case .All:
            return "all"
        case .programming:
            return "programming"
        case .tech:
            return "tech"
        case .web_development:
            return "web development"
        case .software_development:
            return "software development"
        case .javascript:
            return "javascript"
        case .google:
            return "google"
        case .startup:
            return "startup"
        case .security:
            return "security"
        case .docker:
            return "docker"
        case .github:
            return "github"
        case .api:
            return "api"
        case .git:
            return "git"
        case .android_app_development:
            return "android app development"
        case .firebase:
            return "firebase"
        case .push_notification:
            return "push notification"
        case .androiddev:
            return "androiddev"
        case .mobile_app_development:
            return "mobile app development"
        case .computer_science:
            return "computer science"
        case .research:
            return "research"
        case .apple:
            return "apple"
        case .business:
            return "business"
        case .life_lessons:
            return "life lessons"
        case .data_science:
            return "data science"
        case .machine_learning:
            return "machine learning"
        }
    }
    
    var readable: String {
        return self.description.capitalized
    }
}

public struct Podcast: Codable {
    let _id: String
    let title: String
    let description: String
    let summary: String?
    let date: String
    let link: String
    let guid: String
    let author: String
    let categories: [String]?
    let featuredImage: String?
    let totalFavorites: Int
    let score: Int
    var type: String? = "new"
    var upvoted: Bool?
    var downvoted: Bool?
}

extension Podcast: Equatable {
    public static func ==(lhs: Podcast, rhs: Podcast) -> Bool {
        return lhs._id == rhs._id &&
            lhs.date == rhs.date &&
            lhs.link == rhs.link &&
            lhs.categories ?? [] == rhs.categories ?? [] &&
            lhs.featuredImage == rhs.featuredImage &&
            lhs.score == rhs.score &&
            lhs.type == rhs.type
    }
}

extension Podcast {
    func getLastUpdatedAsDateWith(completion: @escaping (Date?) -> Void) {
        DispatchQueue.global().async {
            // slow calculations performed here
            let date = Date(iso8601String: self.date)
            DispatchQueue.main.async {
                completion(date)
            }
        }
    }
    
    func getLastUpdatedAsDate() -> Date? {
        return Date(iso8601String: self.date)
    }
}

// Extension to go Encodable -> Dictionary
extension Encodable {
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

