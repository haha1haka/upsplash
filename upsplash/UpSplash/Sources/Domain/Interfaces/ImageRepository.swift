//
//  ImageRepository.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/28.
//

import Foundation

protocol ImageRepository {
    func fetchImage() -> [Image]
    func addImage(with item: Image)
    func deleteImage(with item: Image)
}
