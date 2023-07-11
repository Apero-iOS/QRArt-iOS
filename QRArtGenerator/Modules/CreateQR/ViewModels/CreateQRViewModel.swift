//
//  CreateQRViewModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import Foundation
import SwiftUI
import Combine
import MobileAds

class CreateQRViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var countrySelect: Country = Country(code: "US", dialCode: "+1")
    @Published var templateQR: TemplateModel = TemplateModel.defaultObject()
    @Published var indexSelectTemplate: Int = .zero {
        didSet {
            if !templateQR.styles.isEmpty {
                input.prompt = templateQR.styles[indexSelectTemplate].config.positivePrompt
                input.negativePrompt = templateQR.styles[indexSelectTemplate].config.negativePrompt
            }
        }
    }
    @Published var input: QRDetailItem = QRDetailItem()
    @Published var validInput: Bool = false
    @Published var source: CreateQRViewSource = .create
    @Published var showingSelectQRTypeView: Bool = false
    @Published var showingSelectCountryView: Bool = false
    @Published var isShowLoadingView: Bool = false
    @Published var isShowExport: Bool = false
    @Published var imageResult: Image = Image("")
    @Published var showSub: Bool = false
    @Published var showToastError: Bool = false
    @Published var isPush: Bool
    
    var isShowAdsInter: Bool {
        return RemoteConfigService.shared.bool(forKey: .inter_generate) && !UserDefaults.standard.isUserVip
    }
    
    var isShowAdsBanner: Bool {
        return RemoteConfigService.shared.bool(forKey: .banner_tab_bar) && !UserDefaults.standard.isUserVip
    }
    
    private let templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init(source: CreateQRViewSource, indexSelect: Int?, list: TemplateModel?, isPush: Bool = false) {
        self.source = source
        self.isPush = isPush
        if let indexSelect = indexSelect {
            self.indexSelectTemplate = indexSelect + 1
        } else {
            self.indexSelectTemplate = 0
        }
        if let list = list {
            self.templateQR = list
            self.templateQR.styles.insert(createBasicQRItem(), at: 0)
            self.templateQR.styles.swapAt(1, indexSelectTemplate)
            self.indexSelectTemplate = 1
        }
    }
    
    deinit {
        cancellable.removeAll()
    }
    
    func fetchCountry() {
        countries = CountriesFetcher().fetch()
    }
    
    func fetchTemplate() {
        if templateQR.styles.isEmpty {
            templateRepository.fetchTemplate().sink { comple in

            } receiveValue: { [weak self] categories in
                guard let self = self else { return }
                if let categories = categories {
                    categories.forEach { category  in
                        self.templateQR.styles.append(contentsOf: category.styles)
                    }
                    self.templateQR.styles.insert(self.createBasicQRItem(), at: 0)
                }
            }.store(in: &cancellable)
        }
    }

    func generateQR() {
        UserDefaults.standard.generatePerDay += 1
        validInput = true
        if isValidInput() {
            genQR()
        }
    }
    
    public func createIdAds() {
        if isShowAdsInter {
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .inter_generate)
        }
    }
    
    public func showAdsInter() {
        if isShowAdsInter {
            AdMobManager.shared.showIntertitial(unitId: .inter_generate, blockDidDismiss: { [weak self] in
                guard let self = self else { return }
                self.generateQR()
            })
        } else {
            generateQR()
        }
    }
    
    public func onTapGenerate() {
        if UserDefaults.standard.isUserVip {
            generateQR()
        } else {
            if UserDefaults.standard.generatePerDay >= RemoteConfigService.shared.number(forKey: .subGenerateQr) {
                // show sub
                showSub = true
            } else {
                // show ads
                showAdsInter()
            }
        }
    }
    
    func isValidInput() -> Bool {
        if validName() && validPrompt() {
            switch input.type {
            case .website:
                return !input.urlString.isEmptyOrWhitespace()
            case .contact:
                return !input.contactName.isEmptyOrWhitespace() && !input.phoneNumber.isEmptyOrWhitespace()
            case .email:
                return !input.emailAddress.isEmptyOrWhitespace() && !input.emailSubject.isEmptyOrWhitespace() && !input.emailDescription.isEmptyOrWhitespace() && QRHelper.isValidEmail(input.emailAddress)
            case .text:
                return !input.text.isEmptyOrWhitespace()
            case .whatsapp:
                return !input.phoneNumber.isEmptyOrWhitespace()
            case .instagram, .facebook, .twitter, .spotify, .youtube:
                return !input.urlString.isEmptyOrWhitespace()
            case .wifi:
                return !input.wfSsid.isEmptyOrWhitespace() && !input.wfPassword.isEmptyOrWhitespace()
            case .paypal:
                return !input.urlString.isEmptyOrWhitespace()
            }
        } else {
            return false
        }
    }
    
    func validName() -> Bool {
        return !input.name.isEmptyOrWhitespace() && input.name.count < 50
    }
    
    func validPrompt() -> Bool {
        return !input.prompt.isEmpty && !input.negativePrompt.isEmpty
    }
    
    func genQRLocal(text: String) -> Data? {
        return QRHelper.genQR(text: text)
    }
    
    func createBasicQRItem() -> Style {
        Style(id: "",
              project: "",
              name: "",
              key: "", category: "", prompt: "", config: Config(negativePrompt: "", positivePrompt: ""), version: "", createdAt: "", updatedAt: "", v: 0)
    }
    
    func genQR() {
        guard let data = genQRLocal(text: getQRText()) else { return }
        isShowLoadingView.toggle()
        templateRepository.genQR(data: data,
                                 qrText: getQRText(),
                                 positivePrompt: input.prompt,
                                 negativePrompt: input.negativePrompt,
                                 guidanceScale: Int(input.guidance),
                                 numInferenceSteps: Int(input.steps),
                                 controlnetConditioningScale: Int(input.contronetScale))
        .sink { [weak self] comple in
            guard let self = self else { return }
            switch comple {
                case .finished:
                    self.isShowLoadingView.toggle()
                case .failure:
                    self.isShowLoadingView.toggle()
                    self.showToastError.toggle()
            }
        } receiveValue: { [weak self] data in
            guard let self = self,
                  let data = data,
                  let uiImage = UIImage(data: data) else {
                self?.showToastError.toggle()
                return
            }
            self.input.qrImage = uiImage
            self.imageResult = Image(uiImage: uiImage)
            self.isShowExport.toggle()
        }.store(in: &cancellable)

    }
    
    func getQRText() -> String {
        switch input.type {
        case .website, .instagram, .facebook, .twitter, .spotify, .youtube:
            return input.urlString
        case .contact, .whatsapp:
            return input.phoneNumber
        case .email:
            return "MATMSG:TO:\(input.emailAddress);SUB:\(input.emailSubject);BODY:\(input.emailDescription);;"
        case .text:
            return input.text
        case .wifi:
            let mode = WifiSecurityMode(rawValue: input.indexWfSecurityMode) ?? .wpa2
            input.wfSecurityMode = mode
            return "WIFI:S:\(input.wfSsid);P:\(input.wfPassword);T:\(input.wfSecurityMode.title);;"
        case .paypal:
            return "\(input.urlString)/\(input.paypalAmount)"
        }
    }
}
