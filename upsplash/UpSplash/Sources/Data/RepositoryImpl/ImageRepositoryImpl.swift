//
//  ImageRepositoryImpl.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/28.
//

import Foundation
import RealmSwift

final class ImageRepositoryImpl: ImageRepository {
    
    let storage = try! Realm()
    
    func fetchImage() -> [Image] {
        return storage.objects(ImageDTO.self).toArray.map { $0.toDomain }
    }
    
    func addImage(with item: Image) {
        do {
            try storage.write {
                storage.add(item.toRealm)
            }
        } catch let error {
            print("Add error: \(error.localizedDescription)")
        }
    }

    func deleteImage(with item: Image) {
        
        if let dbItem = storage.objects(ImageDTO.self).first(where: { $0.id == item.id }) {
            do {
                try storage.write {
                    storage.delete(dbItem)
                }
            } catch let error {
                print("Delete error: \(error.localizedDescription)")
            }
        }
    }
}

