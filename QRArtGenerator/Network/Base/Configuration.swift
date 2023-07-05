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
    case devGenImage
    case stgGenImage
    case productGenImage
    
    var desc : String {
        switch self {
            case .dev :
                return "https://style-management-api.dev.apero.vn"
            case .stg :
                return "https://style-management-api.stg.apero.vn"
            case .product:
                return "https://api-style-manager.apero.vn"
            case .devGenImage:
                return "https://image-generator.dev.apero.vn"
            case .stgGenImage, .productGenImage:
                return "https://api-img-gen-wrapper.apero.vn"
                
        }
    }
}
