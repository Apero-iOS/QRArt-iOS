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
    @Published var typeQR: QRType = .contact
    @Published var countries: [Country] = []
    @Published var countrySelect: Country = Country(code: "VN", dialCode: "+84")
    private var templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        cancellable.removeAll()
    }
    
    func fetchCountry() {
        countries = CountriesFetcher().fetch()
    }
    
    func fetchTemplate() {
        templateRepository.fetchTemplate(page: 1, limit: 20).sink { comple in
            switch comple {
            case .finished:
                print("tuanlt: finished")
            case .failure(let error):
                print("tuanlt: \(error)")
            }
        } receiveValue: { templates in
            print("tuanlt: \(templates)")
        }.store(in: &cancellable)
    }
}
