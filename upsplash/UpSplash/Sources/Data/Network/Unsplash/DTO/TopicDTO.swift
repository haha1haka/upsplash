//
//  TopicDTO.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

struct TopicDTO: Codable {
    let id: String
    let title: String
    let coverPhoto: CoverPhotoDTO
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case coverPhoto = "cover_photo"
    }
}

struct CoverPhotoDTO: Codable {
    let urls: UrlsDTO
}

struct UrlsDTO: Codable {
    let regular: String
}

extension TopicDTO {
    var toDomain: Topic {
        return .init(id: id, title: title, coverPhoto: coverPhoto.toDomain)
    }
}

extension CoverPhotoDTO {
    var toDomain: CoverPhoto {
        return .init(urls: urls.toDomain)
    }
}
extension UrlsDTO {
    var toDomain: Urls {
        return .init(regular: regular)
    }
}


