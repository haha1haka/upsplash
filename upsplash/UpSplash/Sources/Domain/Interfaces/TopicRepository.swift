//
//  TopicRepository.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

protocol TopicRepository {
    func fetchTopicList(completion: @escaping (Result<[Topic], NetworkError>) -> Void)
}
