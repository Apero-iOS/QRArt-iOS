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
    @Published var searchItems: [QRItem] = QRItemService.shared.getQRItems()
    var isCheckFocusSearch: Bool = true
    
    private var totalItems: [QRItem] = QRItemService.shared.getQRItems()
    
    func search() {
        let key = searchKey.trim
        searchItems = key.isEmpty ? totalItems : totalItems.filter({ $0.name.trim.lowercased().contains(key.lowercased()) })
    }
}
