//
//  SearchViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 01/07/2023.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchKey: String = "" {
        didSet {
            search()
        }
    }
    @Published var searchItems: [QRItem] = []
    
    func search() {
        let key = searchKey.trimmingCharacters(in: .whitespacesAndNewlines)
        searchItems = itemTest.filter({ $0.name.lowercased().contains(key.lowercased()) })
    }
}
