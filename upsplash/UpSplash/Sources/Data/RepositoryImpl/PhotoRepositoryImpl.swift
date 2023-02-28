//
//  PhotoRepositoryImpl.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation
import Combine

final class PhotoRepositoryImpl: PhotoRepository {
    
    private let session: UnsplashService
    private var anyCancellable = Set<AnyCancellable>()
    
    init(session: UnsplashService) {
        self.session = session
    }
        
    func fetch(id: String) -> AnyPublisher<[Photo], NetworkError> {
        
        return Future<[Photo], NetworkError> { promiss in
            self.session.request(target: UnsplashRouter.photo(id: id), type: [PhotoDTO].self)
                .sink { completion in

                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                    
                } receiveValue: { photoDTO in
                    let photoList = photoDTO.map { $0.toDomain }
                    promiss(.success(photoList))
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
        
    }
}
