//
//  TemplateNetworking.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

enum TemplateNetworking {
    case fetchTemplate
    case genQR(qrText: String, positivePrompt: String?, negativePrompt: String?, guidanceScale: Int, numInferenceSteps: Int)
}

extension TemplateNetworking: TargetType {
    
    var baseURL: BaseURLType {
        switch self {
        case .fetchTemplate:
#if DEV
        return .dev
#else
        return .product
#endif
        case .genQR:
#if DEV
            return .devGenImage
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
            return .requestParms(path: "/qr-styles", params: ["project": APP_NAME])
        case .genQR:
#if DEV
            return .plainParams(path: "/api/v1/qr")
#else
            return .plainParams(path: "/api/v2/qr")
#endif
        }
    }
    
    var body: Body {
        switch self {
        case .fetchTemplate:
            return .requestPlainBody
        case .genQR(qrText: let qrText, positivePrompt: let positivePrompt, negativePrompt: let negativePrompt, guidanceScale: let guidanceScale, numInferenceSteps: let numInferenceSteps):
            print("Params: qrtext: \(qrText.trimmingCharacters(in: .whitespaces)), prompt: \(positivePrompt?.trimmingCharacters(in: .whitespaces) ?? ""), negativepromt: \(negativePrompt?.trimmingCharacters(in: .whitespaces) ?? ""), gui: \(guidanceScale), numInferenceSteps: \(numInferenceSteps)")
            return .requestBody(body: ["qrText": qrText.trimmingCharacters(in: .whitespaces),
                                       "positivePrompt": positivePrompt?.trimmingCharacters(in: .whitespaces) ?? "",
                                       "negativePrompt": negativePrompt?.trimmingCharacters(in: .whitespaces) ?? "",
                                       "guidanceScale": guidanceScale,
                                       "numInferenceSteps": numInferenceSteps])
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
