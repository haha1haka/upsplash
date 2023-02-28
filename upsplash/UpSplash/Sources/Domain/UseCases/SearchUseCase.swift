//
//  SearchUseCase.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/27.
//

import Foundation
import Combine

protocol SearchUseCase {
    func excute(text: String) -> AnyPublisher<Search, NetworkError>
}

final class SearchUseCaseImpl: SearchUseCase {
    let searchRepository: SearchRepository
    private var anyCancellable = Set<AnyCancellable>()
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    func excute(text: String) -> AnyPublisher<Search, NetworkError> {
        
        return Future<Search, NetworkError> { [weak self] promiss in
            guard let self = self else { return }
            self.searchRepository.fetchSearchedPhotoList(text: text)
                .sink { completion in
                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                } receiveValue: { searchList in
                    promiss(.success(searchList))
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
    }
    
}
