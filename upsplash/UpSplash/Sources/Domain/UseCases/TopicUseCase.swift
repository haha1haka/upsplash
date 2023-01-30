//
//  TopicUseCase.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

protocol TopicUseCase {
    func excute(completion: @escaping (Result<[Topic], NetworkError>) -> Void)
}

final class TopicUseCaseImpl: TopicUseCase {
    private let topicRepository: TopicRepository
    
    init(topicRepository: TopicRepository) {
        self.topicRepository = topicRepository
    }
    
    func excute(completion: @escaping (Result<[Topic], NetworkError>) -> Void) {
        topicRepository.fetchTopicList { result in
            switch result {
            case .success(let topicList):
                completion(.success(topicList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
