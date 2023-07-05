//
//  TabbarViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI
import MobileAds

class TabbarViewModel: ObservableObject, Identifiable {
    @Published var selectedTab: TabbarEnum = .home
    @Published var showScan: Bool = false
    @Published var showCreateQR: Bool = false
    @Published var showIAP: Bool = false
    @Published var countSelectTab: Int = .zero

    var tabs: [TabbarEnum] = TabbarEnum.allCases
    
    var isShowAdsInter: Bool {
        return RemoteConfigService.shared.number(forKey: .inter_change_screen) > .zero && !UserDefaults.standard.isUserVip
    }
    
    public func changeCountSelect() {
        countSelectTab += 1
    }
    
    public func createIdAds() {
        if isShowAdsInter {
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .inter_change_screen)
        }
    }
    
    public func showAdsInter() {
        if isShowAdsInter {
            AdMobManager.shared.showIntertitial(unitId: .inter_change_screen, isSplash: false)
        }
    }
    
    public func getNumberShowAds() -> Int {
        return RemoteConfigService.shared.number(forKey: .inter_change_screen)
    }
}
