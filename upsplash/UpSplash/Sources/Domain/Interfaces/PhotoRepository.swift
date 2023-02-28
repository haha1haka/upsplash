//
//  PhotoRepository.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/27.
//

import Foundation
import Combine

protocol PhotoRepository {
    func fetch(id: String) -> AnyPublisher<[Photo], NetworkError> 
}
