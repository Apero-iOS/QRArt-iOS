//
//  AppHelper.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 29/06/2023.
//

import Foundation
import SwiftUI

struct AppHelper {
    
    public static func getVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
}

struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

