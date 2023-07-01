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
            
        }
    }
    
    func isValidInput() -> Bool {
        if validName() {
            switch input.type {
            case .website:
                return input.link?.isEmpty == false
            case .contact:
                return input.contactName?.isEmpty == false && input.phoneNumber?.isEmpty == false
            case .email:
                return input.emailTo?.isEmpty == false && input.subject?.isEmpty == false && input.emailDesc?.isEmpty == false
            case .text:
                return input.text?.isEmpty == false
            case .whatsapp:
                return input.phoneNumber?.isEmpty == false
            case .instagram, .facebook, .twitter, .spotify, .youtube:
                return input.link?.isEmpty == false
            case .wifi:
                return input.ssid?.isEmpty == false && input.password?.isEmpty == false && input.securityMode?.isEmpty == false
            case .paypal:
                return input.link?.isEmpty == false && input.amount?.isEmpty == false
            }
        } else {
            return false
        }
    }
    
    func validName() -> Bool {
        return !input.name.isEmpty && input.name.count < 50
    }
}
