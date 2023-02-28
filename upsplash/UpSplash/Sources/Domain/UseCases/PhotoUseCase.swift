//
//  PhotoUseCase.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/27.
//

import Foundation
import Combine

protocol PhotoUseCase {
    func excute(id: String) -> AnyPublisher<[Photo], NetworkError>
}

final class PhotoUserCaseImpl: PhotoUseCase {
    private let photoRepository: PhotoRepository
    private var anyCancellable = Set<AnyCancellable>()
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func excute(id: String) -> AnyPublisher<[Photo], NetworkError> {
        
        return Future<[Photo], NetworkError> { [weak self] promiss in
            guard let self = self else { return }
            self.photoRepository.fetch(id: id)
                .sink { completion in
                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                } receiveValue: { photoList in
                    promiss(.success(photoList))
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
    }
        
    
}
