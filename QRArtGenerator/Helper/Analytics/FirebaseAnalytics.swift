//
//  FirebaseAnalytics.swift
//  Docutalk-App
//
//  Created by Le Tuan on 02/06/2023.
//

import Foundation
import FirebaseAnalytics

class FirebaseAnalytics {
    static func logEvent(key: String) {
        Analytics.logEvent(key, parameters: [:])
    }
    
    static func logEvent(type: FirebaseAnalyticsEnum) {
        Analytics.logEvent(type.rawValue, parameters: [:])
    }
    
    static func logEvent(type: FirebaseAnalyticsEnum, params: [FirebaseParamsKey: String]) {
        var paramsDict: [String: String] = [:]
        for param in params {
            paramsDict[param.key.rawValue] = param.value
        }
        Analytics.logEvent(type.rawValue, parameters: paramsDict)
    }
}
