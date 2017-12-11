//
//  VideoRepository.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

class VideoRepository: Repository<Video> {
    typealias RepositorySuccessCallback = ([DataModel]) -> Void
    typealias RepositoryErrorCallback = (RepositoryError) -> Void
    
    private let dataSource = VideoDataSource()
    
    // MARK: Getters With Paging
    let tag = "videos"
    
    var loading = false
    
    func getData(page: Int = 0,
                 filterObject: FilterObject,
                 onSucces: @escaping RepositorySuccessCallback,
                 onFailure: @escaping RepositoryErrorCallback) {
        self.retrieveDataFromRealmOrAPI(filterObject: filterObject, onSucces: { (returnedData) in
            onSucces(returnedData)
        }) { (error) in
            onFailure(error)
        }
    }
    
    // MARK: Disk and API data getter
    private func retrieveDataFromRealmOrAPI(filterObject: FilterObject,
                                            onSucces: @escaping RepositorySuccessCallback,
                                            onFailure: @escaping RepositoryErrorCallback) {
//        // Check if we made requests today
//        //        let alreadLoadedStartToday = self.checkAlreadyLoadedNewToday(filterObject: filterObject)
//        // @TODO: Remove this when we can update local modals
//        let alreadLoadedStartToday = false
//        //@TODO: Fix this special case for recommneded. We can't load from disk here because we are display top podcasts when a user is not logged in
//        if alreadLoadedStartToday && filterObject.type != PodcastTypes.recommended.rawValue {
//            self.loading = true
//            log.warning("from disk")
//            // Check if we have realm data saved
//            self.dataSource.getAllWith(filterObject: filterObject, completion: { (returnedData) in
//                guard let data = returnedData, !data.isEmpty else {
//                    self.loading = false
//                    onFailure(.ErrorGettingFromRealm)
//                    return
//                }
//                guard data != self.lastReturnedDataArray else {
//                    self.loading = false
//                    onFailure(.ReturnedDataEqualsLastData)
//                    return
//                }
//
//                self.setLoadedNewToday(filterObject: filterObject)
//                self.lastReturnedDataArray = data
//                self.loading = false
//                onSucces(data)
//            })
//            return
//        }
        log.warning("from api")
        guard self.loading == false else { return }
        self.loading = true
        
        // @TODO: Remove
        var type = filterObject.type
        if (type == PodcastTypes.recommended.rawValue) {
            type = PodcastTypes.top.rawValue
        }
        
        // API Call and return
        API.sharedInstance.getVideos(onSucces: { (videos) in
            self.loading = false
            guard videos != self.lastReturnedDataArray else {
                onFailure(.ReturnedDataEqualsLastData)
                return
            }
            self.dataSource.insert(items: videos)
            self.setLoadedNewToday(filterObject: filterObject)
            self.lastReturnedDataArray = videos
            onSucces(videos)
        }) { (apiError) in
            self.loading = false
            onFailure(.ErrorGettingFromAPI)
        }
    }
    
    // MARK: Already loaded today checks
    func checkAlreadyLoadedNewToday(filterObject: FilterObject) -> Bool {
        let key = "\(APICheckDates.newFeedLastCheck)-\(filterObject.dictionary)"
        
        let defaults = UserDefaults.standard
        if let newFeedLastCheck = defaults.string(forKey: key) {
            let todayDate = Date().dateString()
            let newFeedDate = Date(iso8601String: newFeedLastCheck)!.dateString()
            if (newFeedDate == todayDate) {
                return true
            }
            
            return false
        }
        return false
    }
    
    func setLoadedNewToday (filterObject: FilterObject) {
        let todayString = Date().iso8601String
        let key = "\(APICheckDates.newFeedLastCheck)-\(filterObject.dictionary)"
        let defaults = UserDefaults.standard
        defaults.set(todayString, forKey: key)
    }
}

extension VideoRepository {
    func updateDataSource(with item: DataModel) {
        self.dataSource.update(item: item)
    }
}
