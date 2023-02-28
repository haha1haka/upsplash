//
//  SearchRepository.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/27.
//

import Foundation
import Combine

protocol SearchRepository {
    func fetchSearchedPhotoList(text: String) -> AnyPublisher<Search, NetworkError> 
}
