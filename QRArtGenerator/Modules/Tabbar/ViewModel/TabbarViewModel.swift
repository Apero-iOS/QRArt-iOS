//
//  TabbarViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI
import MobileAds
import Combine

class TabbarViewModel: ObservableObject, Identifiable {
    @Published var selectedTab: TabbarEnum = .home
    @Published var currentTab: TabbarEnum = .home
    @Published var showScan: Bool = false
    @Published var showCreateQR: Bool = false
    @Published var showIAP: Bool = false
    @Published var countSelectTab: Int = .zero
    @Published var failAds: Bool = false
    @Published var isVip: Bool = UserDefaults.standard.isUserVip
    var cancellable = Set<AnyCancellable>()

    var tabs: [TabbarEnum] = TabbarEnum.allCases
    
    var isShowAdsInter: Bool {
        return RemoteConfigService.shared.number(forKey: .inter_change_screen) > .zero && !UserDefaults.standard.isUserVip
    }
    
    var isShowAdsBanner: Bool {
        return RemoteConfigService.shared.bool(forKey: .banner_tab_bar) && !UserDefaults.standard.isUserVip
    }
    
    var isShowAds: Bool {
        let numberAds = getNumberShowAds()
        return numberAds > .zero && countSelectTab%numberAds == .zero
    }
    
    deinit {
        cancellable.removeAll()
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
            AdMobManager.shared.showIntertitial(unitId: .inter_change_screen, blockWillDismiss: { [weak self] in
                guard let self else {return}
                self.presentScreen()
            })
        }
    }
    
    public func presentScreen() {
        if currentTab == .scan {
            showScan.toggle()
        } else if currentTab == .ai {
            showCreateQR.toggle()
        }
    }
    
    public func getNumberShowAds() -> Int {
        return RemoteConfigService.shared.number(forKey: .inter_change_screen)
    }
    
    public func canShowBannerAd() -> Bool {
        return isShowAdsBanner && !failAds
    }
    
    public func logEventTracking(type: TabbarEnum) {
        switch type {
            case .history:
                FirebaseAnalytics.logEvent(type: .history_click)
            default:
                break
        }
    }
}
