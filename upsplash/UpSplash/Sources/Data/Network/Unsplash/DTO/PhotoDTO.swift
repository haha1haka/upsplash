//
//  PhotoDTO.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: UrlsDTO
}

extension PhotoDTO {
    var toDomain: Photo {
        return Photo(id: id, width: width, height: height, urls: urls.toDomain)
    }
}




