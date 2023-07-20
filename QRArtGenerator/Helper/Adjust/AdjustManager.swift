//
//  AdjustManager.swift
//  EasyPhone
//
//  Created by ANH VU on 24/012/2022.
//

import Foundation
import Adjust
import MobileAds
import SwiftUI

extension AppDelegate: AdjustDelegate {
    func configAdjust() {
        let appToken = "isu1l7ovomps"
        let environment = Constants.isDev ? ADJEnvironmentSandbox : ADJEnvironmentProduction
        let adjustConfig = ADJConfig(appToken: appToken, environment: environment)
        
        // Change the log level.
        adjustConfig?.logLevel = ADJLogLevelVerbose
        
        adjustConfig?.delegate = self
        
        Adjust.appDidLaunch(adjustConfig!)
    }
}

class AdjustManager {
    static let shared = AdjustManager()
    private init() {}
    
    private func adjustSubscription(purchase: PurchaseDetails) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(receiptData: let data):
                self.trackingAdjust(data: data, purchase: purchase)
            case .error(error: let error):
                if let url = Bundle.main.appStoreReceiptURL, let data = try? Data(contentsOf: url) {
                    self.trackingAdjust(data: data, purchase: purchase)
                }
                print("\(error)")
            }
        }
    }
    
    
    private func trackingAdjust(data: Data, purchase: PurchaseDetails) {
        
        if let subscription = ADJSubscription(price: purchase.product.price, currency: purchase.product.priceLocale.currencyCode ?? "", transactionId: purchase.transaction.transactionIdentifier ?? "", andReceipt: data) {
            subscription.setTransactionDate(purchase.transaction.transactionDate ?? purchase.originalPurchaseDate)
            subscription.setSalesRegion(purchase.product.priceLocale.regionCode ?? "")
            Adjust.trackSubscription(subscription)
        }
    }
    
    func adjustNewSubscription(purchase: PurchaseDetails) {
        let appleValidator = AppleReceiptValidator(service: Constants.isDev ? .sandbox : .production, sharedSecret: InappManager.share.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receiptData):
                let receptStr = receiptData["latest_receipt"] as? String ?? ""
                if let data = Data(base64Encoded: receptStr) {
                    print("trackingAdjust \(data)")
                    self.trackingAdjust(data: data, purchase: purchase)
                }
            case .error(let error):
                self.adjustSubscription(purchase: purchase)
                print("Fetch receipt failed: \(error.localizedDescription)")
            }
        }
    }
    
    func adjustSubscriptions(purchase: PurchaseDetails) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { result in
            switch result {
            case .success(receiptData: let data):
                self.trackingAdjust(data: data, purchase: purchase)
            case .error(error: let error):
                if let url = Bundle.main.appStoreReceiptURL, let data = try? Data(contentsOf: url) {
                    self.trackingAdjust(data: data, purchase: purchase)
                }
                print("\(error)")
            }
        }
    }
}
