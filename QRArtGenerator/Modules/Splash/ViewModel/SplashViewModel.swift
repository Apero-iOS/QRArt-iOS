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
        if !UserDefaults.standard.isFirstLanguage {
            Router.showFirstLanguage()
        } else if !UserDefaults.standard.didShowOnboarding {
            Router.showOnboarding()
        } else {
            Router.showTabbar()
        }
    }
}
