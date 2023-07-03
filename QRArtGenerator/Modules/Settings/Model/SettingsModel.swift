//
//  SettingsModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 28/06/2023.
//

import Foundation
import SwiftUI

enum SettingType: CaseIterable, Hashable, Identifiable {
    case language
    case privacy_policy
    case terms_of_service
    case rate_app
    case share_app
    case version
    
    var icon: Image {
        switch self {
            case .language:
                return R.image.ic_setting_language.image
            case .privacy_policy:
                return R.image.ic_setting_privacy_policy.image
            case .terms_of_service:
                return R.image.ic_terms_of_service.image
            case .rate_app:
                return R.image.ic_setting_rate_app.image
            case .share_app:
                return R.image.ic_setting_share.image
            case .version:
                return R.image.ic_setting_version.image
        }
    }
    
    var name: String {
        switch self {
            case .language:
                return Rlocalizable.language()
            case .privacy_policy:
                return Rlocalizable.privacy_policy()
            case .rate_app:
                return Rlocalizable.rate_app()
            case .share_app:
                return Rlocalizable.share_app()
            case .version:
                return Rlocalizable.version()
            case .terms_of_service:
                return Rlocalizable.terms_of_service()
        }
    }
    
    var id: UUID {
        switch self {
            default:
                return UUID()
        }
    }
}
