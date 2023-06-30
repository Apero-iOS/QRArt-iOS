//
//  Configuration.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

enum BaseURLType {
    case dev
    case stg
    case product
    
    var desc : String {
        switch self {
        case .dev :
            return "https://style-management-api.dev.apero.vn"
        case .stg :
            return "https://style-management-api.dev.apero.vn"
        case .product:
            return "https://style-management-api.dev.apero.vn"
        }
    }
}
