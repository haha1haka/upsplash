//
//  PhotoRepository.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/27.
//

import Foundation

protocol PhotoRepository {
    func fetch(id: String, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}
