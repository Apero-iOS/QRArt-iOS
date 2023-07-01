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
    @Published var items: [QRItem] = itemTest
    @Published var filteredItems: [QRItem] = []
    @Published var selectedCate: HistoryCategory?
    
    func setupData() {
        if categories.isEmpty {
            getCategories()
            select(category: categories.first)
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
        select(category: selectedCate)
        if filteredItems.isEmpty {
            select(category: categories.first)
        }
        getCategories()
    }
}

let itemTest = [QRItem(id: "1", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date().yesterday, groupType: .basic, type: .email),
                QRItem(id: "2", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date(), groupType: .other, type: .facebook),
                QRItem(id: "3", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date().lastMonth, groupType: .social, type: .instagram),
                QRItem(id: "4", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date(), groupType: .basic, type: .paypal),
                QRItem(id: "5", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date().yesterday, groupType: .social, type: .spotify),
                QRItem(id: "6", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date().yesterday, groupType: .basic, type: .text),
                QRItem(id: "7", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date(), groupType: .basic, type: .twitter),
                QRItem(id: "8", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date().yesterday, groupType: .social, type: .instagram),
                QRItem(id: "9", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date().yesterday, groupType: .other, type: .paypal),
                QRItem(id: "10", qrImage: R.image.image_test.image, name: "QR Art for Youtube Alec benjamin", createdDate: Date().yesterday, groupType: .basic, type: .youtube)]
