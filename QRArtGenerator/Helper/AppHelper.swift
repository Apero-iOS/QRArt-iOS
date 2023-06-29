//
//  AppHelper.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 29/06/2023.
//

import Foundation

struct AppHelper {
    
    public static func getVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
}
