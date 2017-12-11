//
//  VideoDataSource.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation
import Disk

class VideoDataSource: DataSource {
    typealias T = Video
    
    func getAll(completion: @escaping ([T]?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let retrievedObjects = try? Disk.retrieve(DiskKeys.VideoFolder.folderPath, from: .caches, as: [T].self)
            DispatchQueue.main.async {
                completion(retrievedObjects)
            }
        }
    }
    
    func getAllWith(filterObject: FilterObject, completion: @escaping ([T]?) -> Void) {
        self.getAll { (returnedData) in
            DispatchQueue.global(qos: .userInitiated).async {
                //@TODO: Guard
                let filteredObjects = returnedData?.filter({ (video) -> Bool in
                    // @TODO: Filter any of this
                    return video != nil
                })
                
                let dateString = filterObject.lastDate
                if let passedDate = Date(iso8601String: dateString) {
                    //@TODO: Gaurd
                    let dateFilteredObjects = filteredObjects?.filter({ (video) -> Bool in
                        return video.getPublishedAtDate()! < passedDate
                    })
                    //@TODO: Gaurd
                    DispatchQueue.main.async {
                        completion(Array(dateFilteredObjects!.prefix(10)))
                        
                    }
                    return
                }
                DispatchQueue.main.async {
                    // Prefix = to max paging
                    completion(Array(filteredObjects!.prefix(10)))
                    
                }
                return
            }
        }
    }
    
    func getById(id: String, completion: @escaping (T?) -> Void) {
        self.getAll { (returnedData) in
            let foundObject = returnedData?.filter({ (item) -> Bool in
                return item._id == id
            }).first
            completion(foundObject)
        }
        
    }
    
    func insert(item: T) {
        //@TODO: When would this fail
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try Disk.append(item, to: DiskKeys.VideoFolder.folderPath, in: .caches)
            } catch {
                //@TODO: Handle errors?
                // ...
            }
        }
    }
    
    func insert(items: [T]) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try Disk.append(items, to: DiskKeys.VideoFolder.folderPath, in: .caches)
            } catch {
                //@TODO: Handle errors?
                // ...
            }
        }
    }
    
    func update(item: T) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.getIndexById(id: item._id, completion: { (index) in
                guard let index = index else { return }
                self.getAll(completion: { (podcasts) in
                    guard var allPodcasts = podcasts else { return }
                    allPodcasts.remove(at: index)
                    allPodcasts.insert(item, at: index)
                    self.override(with: allPodcasts)
                })
            })
        }
    }
    
    func override(with items: [T]) {
        do {
            try Disk.save(items, to: .caches, as: DiskKeys.VideoFolder.folderPath)
        } catch let error {
            log.error(error.localizedDescription)
        }
    }
    
    func clean() {
        try? Disk.remove(DiskKeys.VideoFolder.rawValue, from: .caches)
    }
    
    func deleteById(id: String) {
        
    }
    
    func getIndexById(id: String, completion: @escaping (Int?) -> Void) {
        self.getAll { (returnedData) in
            let index = returnedData?.index { (item) -> Bool in
                return item._id == id
            }
            completion(index)
        }
    }
    
    //@TODO: We may need to check if items exist?
    //    func checkIfExists(item: Podcast) {
    //        self.getById(id: item._id) { (returnedItem) in
    //            if returnedItem != nil {
    //                log.info("not nil")
    //            }
    //            log.info("nil?")
    //        }
    //    }
}
