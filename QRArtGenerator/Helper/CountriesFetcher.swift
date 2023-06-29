//
//  CountriesFetcher.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import Foundation

class CountriesFetcher {
    
    func fetch() -> [Country] {
        let url = Bundle.main.url(forResource: "countries", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let countries = try! decoder.decode([Country].self, from: data)
        return countries
    }
}
