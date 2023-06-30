//
//  Country.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import Foundation

struct Country: Decodable, Hashable {
    public var flag: String {
        
        return code
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    public let code: String
    public var name: String {
        Locale.current.localizedString(forRegionCode: code) ?? ""
    }
    
    public var title: String {
        
        String(format: "%@ %@", self.flag, self.name)
    }
    public let dialCode: String
    
    public static func getCurrentCountry() -> Country? {
        let locale: NSLocale = NSLocale.current as NSLocale
        let currentCode: String? = locale.countryCode
        return CountriesFetcher().fetch().first(where: { $0.code ==  currentCode})
    }
}
