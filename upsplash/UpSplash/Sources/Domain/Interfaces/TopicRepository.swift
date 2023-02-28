//
//  TopicRepository.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation
import Combine

protocol TopicRepository {
    func fetchTopicList() -> AnyPublisher<[Topic], NetworkError>
}
