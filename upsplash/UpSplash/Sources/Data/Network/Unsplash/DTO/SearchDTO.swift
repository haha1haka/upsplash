//
//  SearchDTO.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/26.
//

import Foundation

struct SearchDTO: Decodable {
    let total: Int
    let totalPages: Int
    let results: [PhotoDTO]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
extension SearchDTO {
    var toDomain: Search {
        return Search(total: total, totalPages: totalPages, results: results.map{$0.toDomain})
    }
}




