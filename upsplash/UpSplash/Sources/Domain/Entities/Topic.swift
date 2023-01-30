//
//  Topic.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

struct Topic: Hashable {
    let id: String
    let title: String
    let coverPhoto: CoverPhoto
    
    enum CodingKeys: String, CodingKey {
        case id,title
        case coverPhoto = "cover_photo"
    }
}

struct CoverPhoto: Hashable {
    let urls: Urls
}

struct Urls: Hashable {
    let regular: String
}
