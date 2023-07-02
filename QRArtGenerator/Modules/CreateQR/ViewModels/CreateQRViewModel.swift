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
    @Published var templateQR: [TemplateModel] = []
    @Published var indexSelectQR: Int = .zero {
        didSet {
            negativePromt = templateQR[indexSelectQR].styles[0].config.negativePrompt
            positivePromt = templateQR[indexSelectQR].styles[0].config.positivePrompt
        }
    }
    @Published var input: QRDetailItem = QRDetailItem()
    @Published var validInput: Bool = false
    @Published var qrImage: UIImage?
    @Published var source: CreateQRViewSource = .create
    @Published var negativePromt: String = ""
    @Published var positivePromt: String = ""
    
    private var templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        cancellable.removeAll()
    }
    
    func fetchCountry() {
        countries = CountriesFetcher().fetch()
    }
    
    init() {
        templateQR.append(createBasicQRItem())
    }
    
    func fetchTemplate() {
        templateRepository.fetchTemplate().sink { comple in
            
        } receiveValue: { templates in
            if let templateQR = templates {
                self.templateQR.append(contentsOf: templateQR)
            }
        }.store(in: &cancellable)
    }
    
    func generateQR() {
        validInput = true
        if isValidInput() {
            print("tuanlt done")
        } else {
            print("tuanlt not done")
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
    
    func createBasicQRItem() -> TemplateModel {
        TemplateModel(id: "basic",
                      styles: [Style(id: "",
                                     project: "",
                                     name: "",
                                     key: "", category: "", prompt: "", config: Config(negativePrompt: "", positivePrompt: ""), version: "", createdAt: "", updatedAt: "", v: 0)], category: Category(id: "", project: "", name: "", createdAt: "", updatedAt: "", v: 0))
    }
    
    func genQR() {
        guard let data = genQRLocal(text: getQRText()) else { return }
        templateRepository.genQR(data: data,
                                 qrText: getQRText(),
                                 seed: 1,
                                 positivePrompt: positivePromt,
                                 negativePrompt: negativePromt)
        .sink { comple in
            switch comple {
            case .finished:
                break
            case .failure(let error):
                break
            }
        } receiveValue: { data in
            var tuan = try? String(data: data!, encoding: .utf8)
            print("tuanlt: \(tuan)")
        }.store(in: &cancellable)

    }
    
    func getQRText() -> String {
        return "asadasd"
    }
}
