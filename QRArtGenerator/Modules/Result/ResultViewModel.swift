//
//  ResultViewModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 04/07/2023.
//

import Foundation
import UIKit
import Combine
import SwiftUI
import MobileAds

enum Resolutions {
    case normal
    case high
    
    var size: CGSize {
        switch self {
        case .normal:
            return CGSize(width: 256, height: 256)
        case .high:
            return CGSize(width: 1024, height: 1024)
        }
    }
}

class ResultViewModel: ObservableObject {
    @Published var item: QRDetailItem
    @Published var isShowSuccessView: Bool = false
    @Published var isShowLoadingView: Bool = false
    @Published var image: Image
    @Published var sheet: Bool = false
    @Published var source: ResultViewSource
    @Published var showIAP: Bool = false
    @Published var toastMessage: String = ""
    @Published var isShowToast: Bool = false
    private let templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    var isCreate: Bool {
        return source == .create
    }
    
    var isShowAdsNative: Bool {
        return RemoteConfigService.shared.bool(forKey: .native_result) && !UserDefaults.standard.isUserVip
    }
    
    var isShowAdsInter: Bool {
        return RemoteConfigService.shared.bool(forKey: .inter_regenerate) && !UserDefaults.standard.isUserVip
    }
    
    init(item: QRDetailItem, image: Image, source: ResultViewSource) {
        self.item = item
        self.image = image
        self.source = source
    }
    
    func save() {
        QRItemService.shared.saveNewQR(item)
        isShowSuccessView = true
    }
    
    func scaleImage(resolutions: Resolutions) -> UIImage? {
        let originalImage = item.qrImage
        UIGraphicsBeginImageContextWithOptions(resolutions.size, false, 0.0)
        originalImage.draw(in: CGRect(x: 0, y: 0, width: resolutions.size.width, height: resolutions.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func download() {
        if let image = scaleImage(resolutions: .normal) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            showToast(message: Rlocalizable.download_success())
        }
    }
    
    func download4k() {
        if UserDefaults.standard.isUserVip {
            if let image = scaleImage(resolutions: .high) {
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                showToast(message: Rlocalizable.download_success())
            }
        } else {
            showIAP = true
        }
    }
    
    func genQRLocal(text: String) -> Data? {
        return QRHelper.genQR(text: text)
    }
    
    func checkShowSub() -> Bool {
        !UserDefaults.standard.isUserVip && UserDefaults.standard.regeneratePerDay >= RemoteConfigService.shared.number(forKey: .subReGenerateQr)
    }
    
    func regenerate() {
        if checkShowSub() {
            showIAP = true
        } else {
            guard let data = genQRLocal(text: getQRText()) else { return }
            UserDefaults.standard.regeneratePerDay += 1
            isShowLoadingView.toggle()
            templateRepository.genQR(data: data,
                                     qrText: getQRText(),
                                     positivePrompt: item.prompt,
                                     negativePrompt: item.negativePrompt,
                                     guidanceScale: Int(item.guidance),
                                     numInferenceSteps: Int(item.steps),
                                     controlnetConditioningScale: Int(item.contronetScale))
            .sink { comple in
                self.isShowLoadingView.toggle()
            } receiveValue: { data in
                guard let data = data, let uiImage = UIImage(data: data) else { return }
                self.item.qrImage = uiImage
                self.image = Image(uiImage: uiImage)
            }.store(in: &cancellable)
        }

    }
    
    func share() {
        sheet.toggle()
    }
    
    func getQRText() -> String {
        switch item.type {
        case .website, .instagram, .facebook, .twitter, .spotify, .youtube:
            return item.urlString
        case .contact, .whatsapp:
            return item.phoneNumber
        case .email:
            return "MATMSG:TO:\(item.emailAddress);SUB:\(item.emailSubject);BODY:\(item.emailDescription);;"
        case .text:
            return item.text
        case .wifi:
            return "WIFI:S:\(item.wfSsid);P:\(item.wfPassword);T:\(item.wfSecurityMode.title);;"
        case .paypal:
            return "\(item.urlString)/\(item.paypalAmount)"
        }
    }
    
    public func createIdAds() {
        if isShowAdsInter {
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .inter_regenerate)
        }
    }
    
    public func showAdsInter() {
        if isShowAdsInter, !checkShowSub() {
            AdMobManager.shared.showIntertitial(unitId: .inter_regenerate, isSplash: false, blockDidDismiss: { [weak self] in
                self?.regenerate()
            })
        } else {
            regenerate()
        }
    }
    
    func showToast(message: String) {
        toastMessage = message
        isShowToast.toggle()
    }
}

