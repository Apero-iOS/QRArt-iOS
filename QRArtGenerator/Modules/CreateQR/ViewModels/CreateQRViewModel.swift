//
//  CreateQRViewModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import Foundation
import SwiftUI
import Combine

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
    
    private let templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init(source: CreateQRViewSource, indexSelect: Int?, list: TemplateModel?) {
        self.source = source
        self.indexSelectTemplate = indexSelect ?? 0
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
        templateRepository.fetchTemplate().sink { comple in
            
        } receiveValue: { templates in
            if let templates = templates?.first {
                self.templateQR = templates
                self.templateQR.styles.insert(self.createBasicQRItem(), at: 0)
            }
        }.store(in: &cancellable)
    }
    
    func generateQR() {
        validInput = true
        if isValidInput() {
            genQR()
        }
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
        return input.name.isEmpty && input.name.count < 50
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
        templateRepository.genQR(data: data,
                                 qrText: getQRText(),
                                 seed: 1,
                                 positivePrompt: input.prompt,
                                 negativePrompt: input.negativePrompt)
        .sink { comple in
            switch comple {
            case .finished:
                break
            case .failure:
                break
            }
        } receiveValue: { data in
            var tuan = try? String(data: data!, encoding: .utf8)
            print("tuanlt: \(tuan)")
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
