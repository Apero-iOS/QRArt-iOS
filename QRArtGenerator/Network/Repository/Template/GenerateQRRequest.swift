//
//  GenerateQRRequest.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import Foundation

struct GenerateQRRequest {
    var file: Data
    var qrText: String
    var seed: Int
    var positivePrompt: String
    var negativePrompt: String
}
