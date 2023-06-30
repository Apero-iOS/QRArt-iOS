//
//  SuccessResponse.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

struct SuccessResponse<M: Decodable>: Decodable {
    var data: M?
    var success: Bool?
    var statusCode: Int?
}
