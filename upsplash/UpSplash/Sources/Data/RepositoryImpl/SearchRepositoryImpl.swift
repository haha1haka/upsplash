//
//  SearchRepositoryImpl.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

final class SearchRepositoryImpl: SearchRepository {
    
    private let session: UnsplashService
    
    init(session: UnsplashService) {
        self.session = session
    }
    
    func fetchSearchedPhotoList(text: String, completion: @escaping (Result<Search, NetworkError>) -> Void) {
        session.request(target: UnsplashRouter.search(query: text), type: SearchDTO.self) { result in
            switch result {
            case .success(let search):
                completion(.success(search.toDomain))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


