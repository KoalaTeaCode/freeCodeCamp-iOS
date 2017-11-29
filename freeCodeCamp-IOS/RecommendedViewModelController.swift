//
//  RecommendedViewModelController.swift
//  freeCodeCamp-IOS
//
//  Created by Keith Holliday on 11/29/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

public class RecommendedViewModelController {
    typealias Model = Podcast
    typealias ViewModel = PodcastViewModel
    typealias SuccessCallback = () -> Void
    typealias ErrorCallback = (RepositoryError?) -> Void
    
    fileprivate let repository = PodcastRepository()
    fileprivate var viewModels: [ViewModel?] = []
    fileprivate var recommendedViewModels: [ViewModel?] = []
    
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
    
    func update(with podcast: PodcastViewModel) {
        let index = self.viewModels.index { (item) -> Bool in
            return item?._id == podcast._id
        }
        guard let modelsIndex = index else { return }
        self.viewModels.remove(at: modelsIndex)
        self.viewModels.insert(podcast, at: modelsIndex)
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
        getDataFromRepository(filterObject: filterObject, onSucces: onSucces, onFailure: onFailure)
    }
    
    func getDataFromRepository (filterObject: FilterObject,
                                onSucces: @escaping SuccessCallback,
                                onFailure: @escaping ErrorCallback) {
        repository.getData(filterObject: filterObject, onSucces: { (podcasts) in
            let newViewModels: [ViewModel?] = podcasts.map { model in
                return ViewModel(podcast: model)
            }
            
            guard !self.viewModels.isEmpty else {
                if (filterObject.type == PodcastTypes.recommended.rawValue) {
                    self.recommendedViewModels.append(contentsOf: newViewModels)
                } else {
                    self.viewModels.append(contentsOf: newViewModels)
                }
                
                // @TODO: Hack way to load the next set
                // We should load in parallel somehow or maybe just change the api to return on result set.. yea that
                if (filterObject.type == PodcastTypes.recommended.rawValue) {
                    let filterObject2 = FilterObject(type: PodcastCategoryIds.startup.readable,
                                                     tags: filterObject.tags,
                                                     lastDate: filterObject.lastDate,
                                                     categories: filterObject.categories)
                    self.getDataFromRepository(filterObject: filterObject2, onSucces: onSucces, onFailure: onFailure)
                } else {
                    onSucces()
                }
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
            
            if (filterObject.type == PodcastTypes.recommended.rawValue) {
                self.recommendedViewModels.append(contentsOf: filteredArray)
            } else {
                self.viewModels.append(contentsOf: filteredArray)
            }
            
            // @TODO: Hack way to load the next set
            // We should load in parallel somehow or maybe just change the api to return on result set.. yea that
            if (filterObject.type == PodcastTypes.recommended.rawValue) {
                let filterObject2 = FilterObject(type: PodcastCategoryIds.startup.readable,
                                                 tags: filterObject.tags,
                                                 lastDate: filterObject.lastDate,
                                                 categories: filterObject.categories)
                self.getDataFromRepository(filterObject: filterObject2, onSucces: onSucces, onFailure: onFailure)
            } else {
                onSucces()
            }
            
        }) { (error) in
            //@TODO: make this not api error
            onFailure(error)
        }
    }
    
    func getModelsForGroup (group: String) -> [ViewModel?] {
        
        if (group == PodcastTypes.recommended.rawValue) {
            return self.recommendedViewModels
        }
        
        let filteredArray = self.viewModels.filter { viewModel in
            return viewModel?.categories?.contains(group) == true
        }
        
        return filteredArray
    }
}
