//
//  LanguageViewModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 02/07/2023.
//

import Foundation

final class LanguageViewModel: ObservableObject, Identifiable {
    var sourceOpen: SourceOpen
    let languages: [LanguageType] = LanguageType.allCases
    @Published var selectedIndex: Int = 0
    
    init(sourceOpen: SourceOpen) {
        self.sourceOpen = sourceOpen
        configData()
    }
    
    func changeLanguageApp() {
        let language = languages[selectedIndex]
        LocalizationSystem.sharedInstance.setLanguage(languageCode: language.rawValue)
//        UserDefaults.standard.isSelectedLanguage = true
        if sourceOpen == .splash {
            Router.showTabbar()
        } else {
//            if RemoteConfigService.shared.bool(forKey: .reward_upload), !UserDefaults.standard.isUserVip {
//                AdMobManager.shared.createAdRewardedIfNeed(unitId: .reward_upload)
//            }
            Router.showTabbar()
        }
       
    }
    
    func configData() {
        let languageKey = LocalizationSystem.sharedInstance.getLanguage()
        if let language = LanguageType(rawValue: languageKey) {
            selectedIndex = languages.firstIndex(of: language) ?? 0
        } else {
            selectedIndex = 0
        }
    }
    
}
