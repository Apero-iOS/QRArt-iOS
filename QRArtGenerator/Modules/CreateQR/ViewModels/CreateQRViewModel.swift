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
    @Published var countrySelect: Country = Country(code: "VN", dialCode: "+84")
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
    
    var isShowAdsInter: Bool {
        return RemoteConfigService.shared.bool(forKey: .inter_generate) && !UserDefaults.standard.isUserVip
    }
    
    private let templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init(source: CreateQRViewSource, indexSelect: Int?, list: TemplateModel?) {
        self.source = source
        if let indexSelect = indexSelect {
            self.indexSelectTemplate = indexSelect + 1
        } else {
            self.indexSelectTemplate = 0
        }
        if let list = list {
            self.templateQR = list
            self.templateQR.styles.insert(createBasicQRItem(), at: 0)
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

            } receiveValue: { templates in
                if let templates = templates?.first {
                    self.templateQR = templates
                    self.templateQR.styles.insert(self.createBasicQRItem(), at: 0)
                }
            }.store(in: &cancellable)
        }
    }
    
    func checkShowSub() -> Bool {
        !UserDefaults.standard.isUserVip && UserDefaults.standard.generatePerDay >= 3
    }
    
    func generateQR() {
        if checkShowSub() {
            showSub = true
        } else {
            UserDefaults.standard.generatePerDay += 1
            validInput = true
            if isValidInput() {
                genQR()
            }
        }
    }
    
    public func createIdAds() {
        if isShowAdsInter {
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .inter_generate)
        }
    }
    
    public func showAdsInter() {
        generateQR()
    }
    
    func isValidInput() -> Bool {
        if validName() {
            switch input.type {
            case .website:
                return !input.urlString.isEmpty
            case .contact:
                return !input.contactName.isEmpty && !input.phoneNumber.isEmpty
            case .email:
                return !input.emailAddress.isEmpty && !input.emailSubject.isEmpty && !input.emailDescription.isEmpty
            case .text:
                return !input.text.isEmpty
            case .whatsapp:
                return !input.phoneNumber.isEmpty
            case .instagram, .facebook, .twitter, .spotify, .youtube:
                return !input.urlString.isEmpty
            case .wifi:
                return !input.wfSsid.isEmpty == false && !input.wfPassword.isEmpty
            case .paypal:
                return !input.urlString.isEmpty == false
            }
        } else {
            return false
        }
    }
    
    func validName() -> Bool {
        return !input.name.isEmpty && input.name.count < 50
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
            if self.isShowAdsInter {
                AdMobManager.shared.showIntertitial(unitId: .inter_generate, isSplash: false, blockDidDismiss: { [weak self] in
                    guard let self = self else { return }
                    self.isShowLoadingView.toggle()
                })
            } else {
                self.isShowLoadingView.toggle()
            }
        } receiveValue: { data in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
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
            return "WIFI:S:\(input.wfSsid);P:\(input.wfPassword);T:\(input.wfSecurityMode.title);;"
        case .paypal:
            return "\(input.urlString)/\(input.paypalAmount)"
        }
    }
}
