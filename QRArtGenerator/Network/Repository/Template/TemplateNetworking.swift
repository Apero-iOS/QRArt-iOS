//
//  TemplateNetworking.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

enum TemplateNetworking {
    case fetchTemplate
    case genQR(data: Data, qrText: String, seed: Int?, positivePrompt: String?, negativePrompt: String?)
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
        case .genQR:
            return .post
        }
    }
    
    var params: Param {
        switch self {
        case .fetchTemplate:
            return .requestParms(path: "/qr-styles/group-by-category", params: ["project": APP_NAME])
        case .genQR:
            return .plainParams(path: "/api/v1/qr")
        }
    }
    
    var body: Body {
        switch self {
        case .fetchTemplate:
            return .requestPlainBody
        case .genQR(data: let data, qrText: let qrText, seed: let seed, positivePrompt: let positivePrompt, negativePrompt: let negativePrompt):
            return .requestBody(body: ["file": data,
                                       "qrText": qrText,
                                       "seed": seed,
                                       "positivePrompt": positivePrompt,
                                       "negativePrompt": negativePrompt])
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
