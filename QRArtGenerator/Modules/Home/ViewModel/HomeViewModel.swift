//
//  HomeViewModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 30/06/2023.
//

import Foundation
import Combine
import SwiftUI
import MobileAds

final class HomeViewModel: ObservableObject, Identifiable {
    
    @Published var categories: [Category] = []
    @Published var templates: [Template] = AppHelper.templates
    @Published var isShowGenerateQR = false
    @Published var isShowToast = false
    @Published var showIAP = false
    @Published var msgError: String = ""
    @Published var isLoadAd: Bool = (RemoteConfigService.shared.bool(forKey: .native_home) && !UserDefaults.standard.isUserVip)
    var nativeViews: [UIView] = []
    private var templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetchTemplate()
    }
    
    func fetchTemplate() {
        templateRepository.fetchTemplates().sink { [weak self] comple in
            guard let self = self else { return }
            switch comple {
            case .finished:
                break
            case .failure(let error):
                self.msgError = error.message
                self.isShowToast.toggle()
            }
        } receiveValue: { [weak self] listTemplates in
            guard let self = self else { return }
        
            
            let root = UIApplication.shared.windows.first?.rootViewController
            if RemoteConfigService.shared.bool(forKey: .native_home), !UserDefaults.standard.isUserVip {
              
                if let templates = listTemplates?.items {
                    let countAd = templates.count/3 + 1
                    nativeViews.removeAll()
                    for _ in 0...countAd {
                        nativeViews.append(UIView())
                    }
                }
                AdMobManager.shared.removeAd(unitId: AdUnitID.native_home.rawValue)
                AdMobManager.shared.addAdNative(unitId: .native_home, rootVC: root!, views: nativeViews, type: .freeSize)
                AdMobManager.shared.blockNativeFaild = { [weak self] id in
                    if id == AdUnitID.native_home.rawValue {
                        self?.isLoadAd = false
                    }
                }
            } else {
                if isLoadAd {
                    isLoadAd = false
                }
            }

            self.templates.removeAll()
            if let templates = listTemplates?.items {
                self.templates.append(contentsOf: templates)
                AppHelper.templates = templates
            }
            
        }.store(in: &cancellable)
    }
    
    func isShowSelectInter() -> Bool {
        if UserDefaults.standard.isUserVip || !RemoteConfigService.shared.bool(forKey: .inter_template) {
            return false
        }
        let start = 2
        let step = 3
        if UserDefaults.standard.templateSelectCount == 2 {
            return true
        }
        if (UserDefaults.standard.templateSelectCount - start)%3 == 0 {
            return true
        }
        return false
    }
}
