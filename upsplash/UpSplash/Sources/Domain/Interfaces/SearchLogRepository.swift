//
//  SearchLogRepository.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/29.
//

import Foundation

protocol SearchLogRepository {
    func fetchSearchLog() -> [SearchLog]
    func addSearchLog(with item: SearchLog)
    func deleteSearchLog(with item: SearchLog)
    func deleteAllSearchLog()
}
