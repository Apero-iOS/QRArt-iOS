//
//  FailureResponse.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

struct FailureResponse: Codable {
    var success: Bool
    var error: ErrorResponse
}

struct ErrorResponse: Codable {
    var errorCode: Int
    var errorKey: String
    var errorMessage: String
    var devMessage: String
}
