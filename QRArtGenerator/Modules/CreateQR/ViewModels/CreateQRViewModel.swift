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
    @Published var templateQR: [TemplateModel] =  []
    @Published var indexSelectQR: Int = .zero
    @Published var input: CreateQRInput = CreateQRInput()
    @Published var validInput: Bool = false
    @Published var qrImage: UIImage?
    
    private var templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        cancellable.removeAll()
    }
    
    func fetchCountry() {
        countries = CountriesFetcher().fetch()
    }
    
    func fetchTemplate() {
        templateRepository.fetchTemplate().sink { comple in
            switch comple {
            case .finished:
                print("tuanlt: finished")
            case .failure(let error):
                print("tuanlt: \(error)")
            }
        } receiveValue: { templates in
            if let templateQR = templates?.items {
                self.templateQR = templateQR
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
                return !input.link.isEmpty
            case .contact:
                return !input.contactName.isEmpty && !input.phoneNumber.isEmpty
            case .email:
                return !input.emailTo.isEmpty && !input.subject.isEmpty && !input.emailDesc.isEmpty
            case .text:
                return !input.text.isEmpty
            case .whatsapp:
                return !input.phoneNumber.isEmpty
            case .instagram, .facebook, .twitter, .spotify, .youtube:
                return !input.link.isEmpty
            case .wifi:
                return !input.ssid.isEmpty && !input.password.isEmpty && !input.securityMode.isEmpty
            case .paypal:
                return !input.link.isEmpty && !input.amount.isEmpty
            }
        } else {
            return false
        }
    }
    
    func validName() -> Bool {
        return !input.name.isEmpty && input.name.count < 50
    }
    
    func genQR(text: String) {
        DispatchQueue.main.async {
            self.qrImage = QRHelper.genQR(text: text)
        }
        
    }
}
