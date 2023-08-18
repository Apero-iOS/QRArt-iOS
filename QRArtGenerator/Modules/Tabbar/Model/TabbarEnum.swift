//
//  File.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI

enum TabbarEnum: CaseIterable {
    case home
    case scan
    case ai
    case history
    case settings
    
    var title: String {
        switch self {
        case .home:
            return Rlocalizable.home()
        case .scan:
            return Rlocalizable.scan()
        case .ai:
            return Rlocalizable.scan()
        case .history:
            return Rlocalizable.my_qr()
        case .settings:
            return Rlocalizable.settings()
        }
    }
    
    var icon: Image {
        switch self {
        case .home:
            return R.image.home_ic.image
        case .scan:
            return R.image.scan_ic.image
        case .ai:
            return Image("")
        case .history:
            return R.image.ic_my_qr.image
        case .settings:
            return R.image.setting_ic.image
        }
    }
    
    var selectedIcon: Image {
        switch self {
        case .home:
            return R.image.home_selected_ic.image
        case .scan:
            return R.image.scan_selected_ic.image
        case .ai:
            return Image("")
        case .history:
            return R.image.ic_my_qr_selected.image
        case .settings:
            return R.image.setting_selected_ic.image
        }
    }
}
