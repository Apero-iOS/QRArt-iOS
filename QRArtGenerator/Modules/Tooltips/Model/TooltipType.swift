//
//  TooltipType.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 25/07/2023.
//

import SwiftUI

enum TooltipType {
    case home
    case qrType
    case generate
    
    var alignment: Alignment {
        switch self {
        case .home, .generate:
            return .bottom
        case .qrType:
            return .top
        }
    }
    
    var stepString: String {
        switch self {
        case .home, .generate:
            return ""
        case .qrType:
            return "2/3"
        }
    }
}
