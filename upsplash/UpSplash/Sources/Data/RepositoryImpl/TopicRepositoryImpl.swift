//
//  TopicRepositoryImpl.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

final class TopicRepositoryImpl: TopicRepository {

    private let session: UnsplashService
    
    init(session: UnsplashService) {
        self.session = session
    }
    
    func fetchTopicList(completion: @escaping (Result<[Topic], NetworkError>) -> Void) {
        session.request(target: UnsplashRouter.topic, type: [TopicDTO].self) { result in
            switch result {
            case .success(let topicDTO):
                let topicList = topicDTO.map { $0.toDomain }
                completion(.success(topicList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
