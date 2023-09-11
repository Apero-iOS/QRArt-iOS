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
    @Published var countrySelect: Country
    @Published var templates: [Template] = []
    @Published var isShowPopupCreate: Bool = false
    @Published var isShowViewChooseStyle: Bool = false
    @Published var isShowChoosePhoto: Bool = false
    @Published var baseUrl: String = ""
    @Published var input: QRDetailItem = QRDetailItem() {
        didSet {
            if input.type != oldValue.type {
                validInput = false
                resetInput()
            }
        }
    }
    @Published var prompt: String = ""
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
    @Published var qrImage: UIImage?
    @Published var mode: AdvancedSettingsMode = .collapse
    @Published var idTemplateSelect: String?
    @Published var templateSelect: Template
    @Published var isLoadAdsSuccess: Bool = true
    @Published var errorInputType: TextFieldType?
    @Published var promptSample: PromptSample = PromptSample()
    @Published var isShowSub: Bool = false {
        didSet {
            checkShowLoading()
        }
    }
    @Published var isShowToolTipGenerate = false
    @Published var promptInput = ""
    
    private var needFetchTemplates: Bool = true
    
    deinit {
        print("deinit CreateQRViewModel")
        cancellable.forEach({$0.cancel()})
    }
    
    let listPromptSuggess = PromptSuggessType.allCases
        
    var messageError: String = ""
    var isStatusGenegate: Bool = false
    var isGenegateSuccess: Bool = false
    
    var isShowAdsReward: Bool {
        return RemoteConfigService.shared.bool(forKey: .reward_generator) && !UserDefaults.standard.isUserVip
    }
    
    var isShowAdsBanner: Bool {
        return false
        //return RemoteConfigService.shared.bool(forKey: .banner_tab_bar) && !UserDefaults.standard.isUserVip
    }
    
    private let templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init(source: CreateQRViewSource, templateSelect: Template, isPush: Bool = false, qrImage: UIImage? = nil, baseUrl: String? = nil) {
        self.source = source
        self.isPush = isPush
        self.baseUrl = baseUrl ?? ""
        self.qrImage = qrImage
        self.templateSelect = templateSelect
        if let code = Locale.current.regionCode, let dialCode = code.getCountryCallingCode() {
            self.countrySelect = Country(flag: String.emojiFlag(for: code), code: code, dialCode: dialCode)
        } else {
            self.countrySelect = Country(flag: "US", code: "US", dialCode: "+1")
        }
  
        self.input.prompt = templateSelect.positivePrompt
        self.input.negativePrompt = templateSelect.negativePrompt ?? ""
        self.input.templateQRName = templateSelect.name
        self.input.createType = qrImage != nil ? .normal : .custom
        self.input.baseUrl = baseUrl
        self.input.createdDate = Date()
        self.templates.insert(Template(), at: 0)
    }
    
    func fetchCountry() {
        countries = CountriesFetcher().fetch()
    }
    
    func fetchTemplate() {
        if needFetchTemplates {
            templateRepository.fetchTemplates().sink { comple in
                switch comple {
                case .finished:
                    self.needFetchTemplates = false
                case .failure:
                    break
                }
            } receiveValue: { [weak self] listTemplates in
                guard let self = self else { return }
                if let listTemplates = listTemplates {
                    self.templates.append(contentsOf: listTemplates.items)
                }
            }.store(in: &cancellable)
        }
    }
    
    func generateQR() {
        validInput = true
        errorInputType = getErrorInput()
        if errorInputType == nil {
            genQR()
        }
    }
    
    public func createIdAds() {
        if isShowAdsReward {
            AdMobManager.shared.createAdRewardedIfNeed(unitId: .reward_generator)
        }
    }
    
    public func showAdsReward() {
        if isShowAdsReward {
            AdMobManager.shared.showRewarded(unitId: .reward_generator, completion: { [weak self] status in
                guard let self else { return }
                if status {
                    self.generateQR()
                }
            })
        } else {
            generateQR()
        }
    }
    
    public func onTapGenerate() {
        FirebaseAnalytics.logEvent(type: .qr_creation_generate_click)
        validInput = true
        errorInputType = getErrorInput()
     
        if errorInputType == nil {
            let numberLimitGenerate = RemoteConfigService.shared.number(forKey: .generate_sub_times)
            if UserDefaults.standard.generateQRCount == 0 || UserDefaults.standard.isUserVip {
                generateQR()
            } else if RemoteConfigService.shared.bool(forKey: .reward_generator), UserDefaults.standard.generateQRCount < numberLimitGenerate {
                isShowPopupCreate.toggle()
            } else {
                showSub.toggle()
            }
        }
    }
    
    func getErrorInput() -> TextFieldType? {
        if qrImage != nil {
            if baseUrl.isEmptyOrWhitespace() {
                return .baseUrl
            }
            input.baseUrl = baseUrl
            return nil
        }
        switch input.type {
        case .website, .facebook, .instagram, .spotify, .youtube, .twitter:
            if input.urlString.isEmptyOrWhitespace() {
                return .link
            }
            let valid = input.urlString.validateURL()
          
            if valid.isValid {
                if let baseUrl = input.type.baseUrl, !input.urlString.lowercased().contains(baseUrl) {
                    return .link
                }
                input.urlString = valid.urlString
            } else {
                return .link
            }
        case .contact:
            if input.phoneNumber.isEmptyOrWhitespace() || !input.phoneNumber.isValidPhone() {
                return .contactPhone
            }
        case .email:
            if input.emailAddress.isEmptyOrWhitespace() || !input.emailAddress.isValidEmail() {
                return .email
            }
            if input.emailSubject.isEmptyOrWhitespace() {
                return .emailSubject
            }
            if input.emailDescription.isEmptyOrWhitespace() {
                return .emailDesc
            }
        case .text:
            if input.text.isEmptyOrWhitespace() {
                return .text
            }
        case .whatsapp:
            if input.phoneNumber.isEmptyOrWhitespace() || !input.phoneNumber.isValidPhone() {
                return .contactPhone
            }
        case .wifi:
            if input.wfSsid.isEmptyOrWhitespace() {
                return .wifiID
            }
            if input.wfPassword.isEmptyOrWhitespace() {
                return .wifiPass
            }
        case .paypal:
            if input.urlString.isEmptyOrWhitespace() {
                return .link
            }
            let valid = input.urlString.validateURL()
            if valid.isValid {
                if !input.paypalAmount.isEmptyOrWhitespace() && Int(input.paypalAmount) != nil {
                    input.urlString = valid.urlString
                } else {
                    return .paypal
                }
            } else {
                return .link
            }
        }
        return nil
    }
    
    func genQR() {
        isShowLoadingView = true
        isStatusGenegate = true
        isGenegateSuccess = false
        let prompt = (input.prompt + ", " + promptInput).trim
        templateRepository.genQR(qrText: getQRText(),
                                 positivePrompt: prompt,
                                 negativePrompt: input.negativePrompt,
                                 guidanceScale: Int(input.guidance),
                                 numInferenceSteps: input.steps)
        .sink { [weak self] comple in
            guard let self = self else { return }
            switch comple {
                case .finished:
                    self.isStatusGenegate = false
                    self.checkShowLoading()
                    QRItemService.shared.saveNewQR(input, isNew: false)
                case .failure(let error):
                    self.isStatusGenegate = false
                    self.checkShowLoading()
                    self.messageError = error.message
                    self.showToastError.toggle()
            }
        } receiveValue: { [weak self] data in
            guard let self = self,
                  let data = data,
                  let uiImage = UIImage(data: data) else {
                self?.messageError = Rlocalizable.could_not_load_data()
                self?.showToastError.toggle()
                return
            }
            UserDefaults.standard.generateQRCount += 1
            self.isGenegateSuccess = true
            self.input.qrImage = uiImage
            if UserDefaults.standard.isUserVip {
                self.imageResult = Image(uiImage: uiImage)
            } else {
                let newSize = CGSize(width: uiImage.size.width*0.8, height: uiImage.size.height*0.8)
                self.imageResult = Image(uiImage: uiImage.resize(newSize))
            }
            
            UserDefaults.standard.generatePerDay += 1
            
        }.store(in: &cancellable)
        
    }
    
    func checkShowLoading() {
        if !isShowSub && isShowLoadingView && !isStatusGenegate {
            if UserDefaults.standard.isUserVip {
                self.isShowLoadingView.toggle()
                if self.isGenegateSuccess == true {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                        self?.isShowExport.toggle()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
                    self?.isShowLoadingView.toggle()
                    if self?.isGenegateSuccess == true {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                            self?.isShowExport.toggle()
                        }
                    }
                })
            }
        }
    }
    
    func getQRText() -> String {
        if qrImage != nil {
            return baseUrl
        }
        switch input.type {
        case .website, .instagram, .facebook, .twitter, .spotify, .youtube:
            return input.urlString
        case .contact, .whatsapp:
            return countrySelect.dialCode + input.phoneNumber
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
    
    func resetInput() {
        input = input.duplicate()
    }
    
    func genSamplePrompt() {
        input.prompt = promptSample.randomPrompt()
    }
    
    func genSampleNegativePrompt() {
        input.negativePrompt = promptSample.randomNegativePrompt()
    }
}
