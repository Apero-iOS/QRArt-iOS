//
//  HistoryViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 29/06/2023.
//

import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    @Published var categories: [HistoryCategory] = []
    @Published var items: [QRItem] = []
    @Published var filteredItems: [QRItem] = []
    @Published var selectedCate: HistoryCategory?
    
    init() {
        QRItemService.shared.setObserver { [weak self] items in
            self?.items = items
            self?.getCategories()
            if self?.selectedCate == nil {
                self?.select(category: self?.categories.first)
            }
        }
    }
    
    func getCategories() {
        categories = [HistoryCategory(type: nil, count: items.count)]
        for type in QRGroupType.allCases {
            let count = items.filter({ $0.groupType == type }).count
            if count > 0 {
                categories.append(HistoryCategory(type: type, count: count))
            }
        }
    }
    
    func select(category: HistoryCategory?) {
        if let cate = category, let type = cate.type {
            filteredItems = items.filter({ $0.groupType == type })
        } else {
            filteredItems = items
        }
        selectedCate = category
    }
    
    func delete(item: QRItem) {
        items.removeAll(where: { $0.id == item.id })
        QRItemService.shared.deleteQR(item)
        select(category: selectedCate)
        if filteredItems.isEmpty {
            select(category: categories.first)
        }
        getCategories()
    }
}
