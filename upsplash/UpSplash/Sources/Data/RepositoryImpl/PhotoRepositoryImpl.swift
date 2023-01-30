//
//  PhotoRepositoryImpl.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

final class PhotoRepositoryImpl: PhotoRepository {
    
    private let session: UnsplashService
    
    init(session: UnsplashService) {
        self.session = session
    }
    
    func fetch(id: String, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        session.request(target: UnsplashRouter.photo(id: id), type: [PhotoDTO].self) { result in
            switch result {
            case .success(let photoDTO):
                completion(.success(photoDTO.map { $0.toDomain }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
