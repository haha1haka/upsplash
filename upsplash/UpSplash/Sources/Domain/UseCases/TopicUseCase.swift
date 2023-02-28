//
//  TopicUseCase.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation
import Combine

protocol TopicUseCase {
    func excute() -> AnyPublisher<[Topic], NetworkError>
}

final class TopicUseCaseImpl: TopicUseCase {
    private let topicRepository: TopicRepository
    private var anyCancellable = Set<AnyCancellable>()
    
    init(topicRepository: TopicRepository) {
        self.topicRepository = topicRepository
    }

    func excute() -> AnyPublisher<[Topic], NetworkError> {
        
        return Future<[Topic], NetworkError> { [weak self] promiss in
            guard let self = self else { return }
            self.topicRepository.fetchTopicList()
                .sink { completion in
                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                } receiveValue: { topicList in
                    promiss(.success(topicList))
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
    }
}
