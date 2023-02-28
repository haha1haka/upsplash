//
//  SearchRepositoryImpl.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation
import Combine

final class SearchRepositoryImpl: SearchRepository {
    
    private let session: UnsplashService
    private var anyCancellable = Set<AnyCancellable>()
    
    init(session: UnsplashService) {
        self.session = session
    }
    func fetchSearchedPhotoList(text: String) -> AnyPublisher<Search, NetworkError> {
        
        return Future<Search, NetworkError> { promiss in
            self.session.request(target: UnsplashRouter.search(query: text), type: SearchDTO.self)
                .sink { completion in

                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                    
                } receiveValue: { searchDTO in
                    let searchList = searchDTO.toDomain
                    promiss(.success(searchList))
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
        
    }

}


