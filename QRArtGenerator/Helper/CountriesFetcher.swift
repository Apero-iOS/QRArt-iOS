//
//  CountriesFetcher.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import Foundation
import SwiftUI

class CountriesFetcher {
    
    func fetch() -> [Country] {
        var countries = [Country]()
        for code in NSLocale.isoCountryCodes  {
            let flag = String.emojiFlag(for: code)
            if let number = code.getCountryCallingCode(), let flag = flag {
                countries.append(Country(flag: flag, code: code, dialCode: number))
            }else{
                //"Country not found for code: \(code)"
            }
        }
        return countries
    }
}
