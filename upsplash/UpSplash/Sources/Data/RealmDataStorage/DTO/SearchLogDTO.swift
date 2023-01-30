//
//  SearchLogDTO.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/29.
//

import Foundation
import RealmSwift

class SearchLogDTO: Object {
    
    @Persisted var text : String

    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}

extension SearchLogDTO {
    var toDomain: SearchLog {
        return SearchLog(text: text)
    }
}

extension SearchLog {
    var toRealm: SearchLogDTO {
        return SearchLogDTO(text: text)
    }
}



