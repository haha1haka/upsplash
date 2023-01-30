//
//  Results.swift
//  UpSplash
//
//  Created by HWAKSEONG KIM on 2023/01/28.
//

import Foundation
import RealmSwift

extension Results {
    var toArray: [Element] {
        return compactMap { $0 }
    }
}
