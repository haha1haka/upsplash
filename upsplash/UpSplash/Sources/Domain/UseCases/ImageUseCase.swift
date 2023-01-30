//
//  ImageUseCase.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/28.
//

import Foundation

protocol ImageUseCase {
    func load() -> [Image]
    func save(with item: Image)
    func delete(with item: Image)
}

final class ImageUseCaseImpl: ImageUseCase {
    let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func load() -> [Image] {
        return imageRepository.fetchImage()
    }
    
    func save(with item: Image) {
        imageRepository.addImage(with: item)
    }
    
    func delete(with item: Image) {
        imageRepository.deleteImage(with: item)
    }

}
