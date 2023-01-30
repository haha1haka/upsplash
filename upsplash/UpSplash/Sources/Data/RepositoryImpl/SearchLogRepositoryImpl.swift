//
//  SearchLogRepositoryImpl.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/29.
//

import Foundation
import RealmSwift

final class SearchLogRepositoryImpl: SearchLogRepository {
    
    let storage = try! Realm()
    
    func fetchSearchLog() -> [SearchLog] {
        return storage.objects(SearchLogDTO.self).toArray.map { $0.toDomain }
    }
    
    func addSearchLog(with item: SearchLog) {
        do {
            try storage.write {
                storage.add(item.toRealm)
            }
        } catch let error {
            print("Add error: \(error.localizedDescription)")
        }
    }
    
    func deleteSearchLog(with item: SearchLog) {
        
        if let dbItem = storage.objects(SearchLogDTO.self).first(where: { $0.text == item.text }) {
            do {
                try storage.write {
                    storage.delete(dbItem)
                }
            } catch let error {
                print("Delete error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAllSearchLog() {
        do {
            try storage.write {
                storage.deleteAll()
            }
        } catch let error {
            print("DeleteAll error: \(error.localizedDescription)")
        }
    }
    

}
