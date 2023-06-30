//
//  CreateQRViewModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import Foundation
import SwiftUI

class CreateQRViewModel: ObservableObject {
    @Published var typeQR: QRType = .contact
    @Published var countries: [Country] = []
    @Published var countrySelect: Country = Country(code: "VN", dialCode: "+84")
    
    
    func fetchCountry() {
        countries = CountriesFetcher().fetch()
    }
}
