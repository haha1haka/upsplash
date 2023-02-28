//
//  TopicRepositoryImpl.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation
import Combine

final class TopicRepositoryImpl: TopicRepository {
    
    private let session: UnsplashService
    private var anyCancellable = Set<AnyCancellable>()
    
    init(session: UnsplashService) {
        self.session = session
    }
        
    func fetchTopicList() -> AnyPublisher<[Topic], NetworkError> {
        
        return Future<[Topic], NetworkError> { promiss in
            self.session.request(target: UnsplashRouter.topic, type: [TopicDTO].self)
                .sink { completion in

                    if case .failure(let error) = completion {
                        switch error {
                        default:
                            promiss(.failure(error))
                        }
                    }
                    
                } receiveValue: { topicDTO in
                    let topicList = topicDTO.map { $0.toDomain }
                    promiss(.success(topicList))
                }
                .store(in: &self.anyCancellable)
        }.eraseToAnyPublisher()
        
    }
    
}
