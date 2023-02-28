//
//  Error.swift
//  LastDance
//
//  Created by HWAKSEONG KIM on 2022/12/30.
//

import Foundation

enum NetworkError: Error {
    case unexpectedData
    case decodingError
    case clientError
    case serverError
    case internalError
}


