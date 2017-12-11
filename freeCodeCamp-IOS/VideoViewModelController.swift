//
//  VideoViewModelController.swift
//  freeCodeCamp-IOS
//
//  Created by Craig Holliday on 12/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

public class VideoViewModelController {
    typealias Model = Video
    typealias ViewModel = VideoViewModel
    typealias SuccessCallback = () -> Void
    typealias ErrorCallback = (RepositoryError?) -> Void
    
    fileprivate let repository = VideoRepository()
    fileprivate var viewModels: [ViewModel?] = []
    
    var viewModelsCount: Int {
        return viewModels.count
    }
    
    func viewModel(at index: Int) -> ViewModel? {
        guard index >= 0 && index < viewModelsCount else { return nil }
        return viewModels[index]
    }
    
    func clearViewModels() {
        self.viewModels.removeAll()
    }
    
    func update(with video: ViewModel) {
        let index = self.viewModels.index { (item) -> Bool in
            return item?._id == video._id
        }
        guard let modelsIndex = index else { return }
        self.viewModels.remove(at: modelsIndex)
        self.viewModels.insert(video, at: modelsIndex)
        self.repository.updateDataSource(with: video.baseModelRepresentation)
    }
    
    func fetchData(type: String = "",
                   createdAtBefore beforeDate: String = "",
                   tags: [Int] = [],
                   categories: [String] = [],
                   page: Int = 0,
                   clearData: Bool = false,
                   onSucces: @escaping SuccessCallback,
                   onFailure: @escaping ErrorCallback) {
        if clearData {
            self.clearViewModels()
        }
        
        let filterObject = FilterObject(type: type, tags: tags, lastDate: beforeDate, categories: categories)
        
        repository.getData(filterObject: filterObject, onSucces: { (podcasts) in
            let newViewModels: [ViewModel?] = podcasts.map { model in
                return ViewModel(video: model)
            }
            
            guard !self.viewModels.isEmpty else {
                self.viewModels.append(contentsOf: newViewModels)
                onSucces()
                return
            }
            
            //@TODO: Do this in the background?
            let filteredArray = newViewModels.filter { newPodcast in
                let contains = self.viewModels.contains { currentPodcast in
                    return newPodcast == currentPodcast
                }
                return !contains
            }
            
            guard filteredArray.count != 0 else {
                // OnFailure Nothing to append
                //@TODO: Change handle error
                onFailure(.ReturnedDataIsZero)
                return
            }
            
            self.viewModels.append(contentsOf: filteredArray)
            onSucces()
        }) { (error) in
            //@TODO: make this not api error
            onFailure(error)
        }
    }
    
    func fetchSearchData(searchTerm: String,
                         createdAtBefore beforeDate: String = "",
                         firstSearch: Bool,
                         onSucces: @escaping SuccessCallback,
                         onFailure: @escaping (APIError?) -> Void) {
        if firstSearch {
            self.clearViewModels()
        }
        API.sharedInstance.getVideosWith(searchTerm: searchTerm, createdAtBefore: beforeDate, onSucces: { (podcasts) in
            let newViewModels: [ViewModel?] = podcasts.map { model in
                return ViewModel(video: model)
            }
            
            guard !self.viewModels.isEmpty else {
                self.viewModels.append(contentsOf: newViewModels)
                onSucces()
                return
            }
            
            //@TODO: Do this in the background?
            let filteredArray = newViewModels.filter { newPodcast in
                let contains = self.viewModels.contains { currentPodcast in
                    return newPodcast == currentPodcast
                }
                return !contains
            }
            
            guard filteredArray.count != 0 else {
                // OnFailure Nothing to append
                //@TODO: Change handle error
                onFailure(.GeneralFailure)
                return
            }
            
            self.viewModels.append(contentsOf: filteredArray)
            onSucces()
        }) { (apiError) in
            //@TODO: handle error
            log.error(apiError?.localizedDescription)
            onFailure(apiError)
        }
    }
}
