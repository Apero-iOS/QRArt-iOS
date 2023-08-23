//
//  SplashViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 02/07/2023.
//

import Foundation
import MobileAds
import Combine

class SplashViewModel: ObservableObject {
    var isTimerDone = PassthroughSubject<Bool, Never>()
    var isFetchRemoteDone = PassthroughSubject<Bool, Never>()
    var isCheckIAPDone = PassthroughSubject<Bool, Never>()
    
    var isShowAds: Bool {
        return RemoteConfigService.shared.bool(forKey: .app_open_splash) && !UserDefaults.standard.isUserVip
    }
    
    func prepareData() {
        FileManagerUtil.shared.createFolder(folder: FileManagerUtil.shared.photoFolderName)
        InappManager.share.veryCheckRegisterPack { [weak self] in
            self?.isCheckIAPDone.send(true)
        }
        RemoteConfigService.shared.fetchCloudValues(complete: { [weak self] _ in
            self?.isFetchRemoteDone.send(true)
        })
    }
    
    func navigateApp() {
        Router.showOnboarding()
//        if !UserDefaults.standard.isFirstLanguage && RemoteConfigService.shared.bool(forKey: .languageFirstOpen) && !UserDefaults.standard.didShowOnboarding {
//            Router.showFirstLanguage()
//        } else if !UserDefaults.standard.didShowOnboarding {
//            Router.showOnboarding()
//        } else {
//            Router.showTabbar()
//        }
    }
    
    func addOpenAd() {
            AdResumeManager.shared.resumeAdId = .app_open_all_price
            AdResumeManager.shared.blockadDidDismissFullScreenContent = { [weak self] in
                guard let self = self else { return }
                self.navigateApp()
            }
            AdResumeManager.shared.loadAd { [weak self] success in
                guard let self = self else { return }
                if success {
                    if let vc = AppHelper.getRootViewController() {
                        AdResumeManager.shared.showAdIfAvailable(viewController: vc)
                    } else {
                        self.navigateApp()
                    }
                } else {
                    self.navigateApp()
                }
            }
        }
    
     func handlePushScreen() {
         if isShowAds {
             addOpenAd()
         } else {
             navigateApp()
         }
    }
}
