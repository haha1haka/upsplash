//
//  ImageURL.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/28.
//

import Foundation
import RealmSwift

class ImageDTO: Object {
    @Persisted var id: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var url: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(id: String, width: Int, height: Int, url: String) {
        self.init()
        self.id = id
        self.width = width
        self.height = height
        self.url = url
    }
}

extension ImageDTO {
    var toDomain: Image {
        return Image(id: id, width: width, height: height, url: url)
    }
}

extension Image {
    var toRealm: ImageDTO {
        return ImageDTO(id: id, width: width, height: height, url: url)
    }
}

