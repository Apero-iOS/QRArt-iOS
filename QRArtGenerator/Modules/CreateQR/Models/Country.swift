//
//  Country.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import Foundation

struct Country: Decodable, Hashable {
    public var flagUrl: URL? {
        return URL(string: "https://flagcdn.com/48x36/\(code.lowercased()).png")
    }
    public let code: String
    public var name: String {
        Locale(identifier: "en_US").localizedString(forRegionCode: code) ?? ""
    }
    
    public var title: String {
        
        return name
    }
    public var dialCode: String
    
    public static func getCurrentCountry() -> Country? {
        let locale: NSLocale = NSLocale.current as NSLocale
        let currentCode: String? = locale.countryCode
        return CountriesFetcher().fetch().first(where: { $0.code ==  currentCode})
    }
    
}
