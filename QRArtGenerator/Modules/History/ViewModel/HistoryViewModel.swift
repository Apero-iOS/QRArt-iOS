//
//  HistoryViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 29/06/2023.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var categories: [Int : String] = [:]
    @Published var items: [QRItem] = itemTest
    @Published var filteredItems: [QRItem] = []
    @Published var selectedCate: QRGroupType?
    
    func getCategories() {
        categories[0] = Rlocalizable.all() + " (\(items.count))"
        var index = 1
        for type in QRGroupType.allCases {
            let count = items.filter({ $0.groupType == type }).count
            if count > 0 {
                categories[index] = type.title + " (\(count))"
                index += 1
            }
        }
    }
    
    func select(category: QRGroupType?) {
        if let cate = category {
            filteredItems = items.filter({ $0.groupType == cate })
        } else {
            filteredItems = items
        }
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
