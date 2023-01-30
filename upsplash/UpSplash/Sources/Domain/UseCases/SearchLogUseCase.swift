//
//  SearchLogUseCase.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/29.
//

import Foundation

protocol SearchLogUseCase {
    func load() -> [SearchLog]
    func save(with item: SearchLog)
    func delete(with item: SearchLog)
    func deleteAll()
}

final class SearchLogUseCaseImpl: SearchLogUseCase {
    let searchLogRepository: SearchLogRepository
    
    init(searchLogRepository: SearchLogRepository) {
        self.searchLogRepository = searchLogRepository
    }
    
    func load() -> [SearchLog] {
        return searchLogRepository.fetchSearchLog()
    }
    
    func save(with item: SearchLog) {
        searchLogRepository.addSearchLog(with: item)
    }

    func delete(with item: SearchLog) {
        searchLogRepository.deleteSearchLog(with: item)
    }
    
    func deleteAll() {
        searchLogRepository.deleteAllSearchLog()
    }
}
