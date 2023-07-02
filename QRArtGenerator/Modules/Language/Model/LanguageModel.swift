//
//  LanguageModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 02/07/2023.
//

import Foundation
import SwiftUI

enum SourceOpen {
    case splash
    case setting
}

enum LanguageType: String, CaseIterable, Identifiable {
    case english = "en"
    case german = "de"
    case french = "fr"
    case spanish = "es"
    case portugese = "pt-PT"
    case vietnamese = "vi"
    
    init?(rawValue: String) {
        if let type = LanguageType.allCases.filter({ rawValue.hasPrefix($0.rawValue) }).first {
            self = type
        } else {
            return nil
        }
    }
    
    var id: UUID {
        switch self {
            default:
                return UUID()
        }
    }
    
    var title: String {
        switch self {
            case .english:
                return "English"
            case .german:
                return "German"
            case .french:
                return "French"
            case .spanish:
                return "Spanish"
            case .portugese:
                return "Portugese"
            case .vietnamese:
                return "Vietnamese"
        }
    }
    
    var icon: Image {
        switch self {
            case .english:
                return R.image.ic_en.image
            case .german:
                return R.image.ic_de.image
            case .french:
                return R.image.ic_fr.image
            case .spanish:
                return R.image.ic_es.image
            case .portugese:
                return R.image.ic_pt.image
            case .vietnamese:
                return R.image.ic_vn.image
        }
    }
}
