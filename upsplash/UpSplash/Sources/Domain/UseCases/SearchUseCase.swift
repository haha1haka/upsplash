//
//  SearchUseCase.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/27.
//

import Foundation

protocol SearchUseCase {
    func excute(text: String, completion: @escaping (Result<Search, NetworkError>) -> Void)
}

final class SearchUseCaseImpl: SearchUseCase {
    let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func excute(text: String, completion: @escaping (Result<Search, NetworkError>) -> Void) {
        searchRepository.fetchSearchedPhotoList(text: text) { result in
            switch result {
            case .success(let photoList):
                completion(.success(photoList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
