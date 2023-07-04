//
//  TemplateNetworking.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

enum TemplateNetworking {
    case fetchTemplate
    case genQR(data: Data, qrText: String, positivePrompt: String?, negativePrompt: String?, guidanceScale: Int, numInferenceSteps: Int, controlnetConditioningScale: Int)
}

extension TemplateNetworking: TargetType {
    
    var baseURL: BaseURLType {
        switch self {
        case .fetchTemplate:
#if DEV
        return .dev
#elseif STG
        return .stg
#else
        return .product
#endif
        case .genQR:
#if DEV
            return .devGenImage
#elseif STG
        return .stgGenImage
#else
        return .productGenImage
#endif
        }

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
        case .genQR(data: let data, qrText: let qrText, positivePrompt: let positivePrompt, negativePrompt: let negativePrompt, guidanceScale: let guidanceScale, numInferenceSteps: let numInferenceSteps, controlnetConditioningScale: let controlnetConditioningScale):
            return .requestBody(body: ["file": data,
                                       "qrText": qrText,
                                       "positivePrompt": positivePrompt,
                                       "negativePrompt": negativePrompt,
                                       "guidanceScale": guidanceScale,
                                       "numInferenceSteps": numInferenceSteps,
                                       "controlnetConditioningScale": controlnetConditioningScale])
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
