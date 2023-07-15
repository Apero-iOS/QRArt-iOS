//
//  IAPIdType.swift
//  VideoEditorPro
//
//  Created by Quang Ly Hoang on 22/12/2022.
//

import Foundation
import MobileAds

enum IAPIdType: String, CaseIterable {
    case week = "qr.art.weeklytrial"
    case month = "qr.art.monthly"
    case lifetime = "qr.art.lifetime"
    case year = "qr.art.yearly"
    
    struct SubscriptionInfo: Decodable {
        let list: String
        let best_price: String
    }
    
    var title: String {
        switch self {
        case .month:
            return Rlocalizable.monthly()
        case .week:
            return Rlocalizable.weekly()
        case .lifetime:
            return Rlocalizable.lifetime()
        case .year:
            return Rlocalizable.yearly()
        }
    }
    
    var id: String {
        return rawValue
    }
    
    var localizedPrice: String {
        return InappManager.share.listProduct.first(where: {$0.productIdentifier == self.id})?.localizedPrice ?? ""
    }
    
    var freeday: Int {
        return InappManager.share.getFreedaysTrial(id: id)
    }
    
    static func getOption() -> [IAPIdType] {
        let info = RemoteConfigService.shared.objectJson(forKey: .subscriptionList, type: SubscriptionInfo.self)
        let list = info?.list ?? ""
        let listId = list.split(separator: ",")
        return listId.compactMap({ IAPIdType(rawValue: $0.trimmingCharacters(in: .whitespaces)) })
    }
    
    static func checkBestPrice(id: String) -> Bool {
        let info = RemoteConfigService.shared.objectJson(forKey: .subscriptionList, type: SubscriptionInfo.self)
        let bestPrice = info?.best_price ?? ""
        let type = IAPIdType(rawValue: bestPrice)
        
        return type?.id == id
    }
}
