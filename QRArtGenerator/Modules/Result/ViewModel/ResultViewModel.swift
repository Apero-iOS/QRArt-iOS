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
import Photos

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
    @Published var isGenQRSuccess: Bool = false
    @Published var image: Image
    @Published var sheet: Bool = false
    @Published var showIAP: Bool = false
    @Published var toastMessage: String = ""
    @Published var isShowToast: Bool = false
    @Published var isShowDeleteAction: Bool = false
    @Published var showPopupAcessPhoto: Bool = false
    @Published var showPopupConfirm: Bool = false
    @Published var isShowIAP = false
    @Published var isShowAd = (!UserDefaults.standard.isUserVip && RemoteConfigService.shared.bool(forKey: .banner_result))
    private let templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    var isSaveQR = false
    
    var isShowAdsInter: Bool {
        return RemoteConfigService.shared.bool(forKey: .inter_regen) && !UserDefaults.standard.isUserVip
    }
    
    var isShowInterCreateMore: Bool {
        return RemoteConfigService.shared.bool(forKey: .inter_createmore) && !UserDefaults.standard.isUserVip
    }
    
    init(item: QRDetailItem, image: Image) {
        self.item = item
        self.image = image
    }
    
    func save() {
        QRItemService.shared.saveNewQR(item, isNew: false)
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
    
    func checkDownload() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized, .limited:
                download()
            case .denied, .restricted :
                showPopupAcessPhoto = true
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                    guard let self = self else { return }
                    switch status {
                        case .authorized, .limited:
                            self.download()
                        default:
                            break
                    }
                }
            default:
                print(status)
        }
    }
    
    func download() {
        if let image = scaleImage(resolutions: .normal) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            showToast(message: Rlocalizable.download_success())
            isSaveQR = true
        }
    }
    
    func dissmissPopupAcessPhoto() {
        showPopupAcessPhoto = false
    }
    
    func checkDownload4K() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized, .limited:
                download4k()
            case .denied, .restricted :
                showPopupAcessPhoto = true
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                    guard let self = self else { return }
                    switch status {
                        case .authorized, .limited:
                            self.download4k()
                        default:
                            self.showPopupAcessPhoto = true
                    }
                }
            default:
                print(status)
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
            isShowLoadingView.toggle()
            templateRepository.genQR(qrText: getQRText(),
                                     positivePrompt: item.prompt,
                                     negativePrompt: item.negativePrompt,
                                     guidanceScale: Int(item.guidance),
                                     numInferenceSteps: Int(item.steps))
            .sink { comple in
                switch comple {
                case .finished:
                    break
                case .failure(let error):
                    self.showToast(message: error.message)
                }
                if UserDefaults.standard.isUserVip {
                    self.isGenQRSuccess = true
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.isGenQRSuccess = true
                    })
                }
            } receiveValue: { data in
                guard let data = data, let uiImage = UIImage(data: data) else {
                    self.showToast(message: Rlocalizable.could_not_load_data())
                    return
                }
                self.item.qrImage = uiImage
                self.image = Image(uiImage: uiImage)
                UserDefaults.standard.regeneratePerDay += 1
            }.store(in: &cancellable)
        }

    }
    
    func share() {
        sheet.toggle()
    }
    
    func getQRText() -> String {
        if let baseUrl = item.baseUrl {
            return baseUrl
        }
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
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .reward_regen)
        }
    }
    
    public func createIdInterCreateMore() {
        if isShowInterCreateMore {
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .inter_createmore)
        }
    }
    
    public func showAdsInter() {
        if isShowAdsInter {
            AdMobManager.shared.showIntertitial(unitId: .inter_regen, blockWillDismiss: { [weak self] in
                self?.regenerate()
            })
        } else {
            regenerate()
        }
    }
    
    public func showInterCreateMore(completion: VoidBlock?) {
        if isShowInterCreateMore {
            AdMobManager.shared.showIntertitial(unitId: .inter_createmore, isSplash: false, blockWillDismiss: {
                completion?()
            })
        } else {
            completion?()
        }
    }
    
    func showToast(message: String) {
        toastMessage = message
        isShowToast.toggle()
    }
    
    func saveAndShare() {
        QRItemService.shared.saveNewQR(item, isNew: false)
        share()
    }
}

