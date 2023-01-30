//
//  PhotoUseCase.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/27.
//

import Foundation

protocol PhotoUseCase {
    func excute(id: String, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}

final class PhotoUserCaseImpl: PhotoUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func excute(id: String, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        photoRepository.fetch(id: id) { result in
            switch result {
            case .success(let photoList):
                completion(.success(photoList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
