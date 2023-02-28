//
//  SearchRepository.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/27.
//

import Foundation

protocol SearchRepository {
    func fetchSearchedPhotoList(text: String, completion: @escaping (Result<Search, NetworkError>) -> Void)
}
