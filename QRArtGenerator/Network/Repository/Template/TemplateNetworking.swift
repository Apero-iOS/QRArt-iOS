//
//  TemplateNetworking.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

enum TemplateNetworking {
    case fetchTemplate(page: Int, limit: Int)
}

extension TemplateNetworking: TargetType {
    
    var baseURL: BaseURLType {
#if DEV
        return .dev
#elseif STG
        return .stg
#else
        return .product
#endif
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTemplate:
            return .get
        }
    }
    
    var params: Param {
        switch self {
        case .fetchTemplate(let page, let limit):
            return .requestParms(path: "/qr-styles", params: ["project": APP_NAME,
                                                              "page": page,
                                                              "limit": limit])
        }
    }
    
    var body: Body {
        switch self {
        case .fetchTemplate:
            return .requestPlainBody
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
