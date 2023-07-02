//
//  InappManager.swift
//  EasyPhone
//
//  Created by ANH VU on 11/01/2022.
//

import Foundation
import StoreKit
import AVFoundation
import Combine
import MobileAds
import Adjust

public typealias ProductIdentifier = String

protocol InappManagerDelegate: AnyObject {
    func purchaseSuccess(id: String)
}

class InappManager {
    
    static let share = InappManager()
    
    let sharedSecret: String = "efb06f373620499b96b23dad199d8c53"
    let productIdentifiers: Set<ProductIdentifier> = Set(IAPIdType.allCases.compactMap{$0.id})
    var listProduct = Set<SKProduct>()
    var didPaymentSuccess = PassthroughSubject<Bool, Never>()
    var productsInfo = CurrentValueSubject<Set<SKProduct>, Never>([])
    var purchasedProduct: IAPIdType?
    var infoPurchaseProduct: ReceiptItem?
    weak var delegate: InappManagerDelegate?
    
//    func showIAPViewController(type: IAPType, completion: BoolBlock?, source: FirebaseParamsValue) {
//        let iapVC = IAPViewController()
//        iapVC.sourceValue = source
//        iapVC.paymentSuccess = completion
//        iapVC.modalPresentationStyle = .fullScreen
//        iapVC.viewModel.iapType = type
//        UIViewController.top()?.present(iapVC, animated: true)
//    }
    
    func getFreedaysTrial(id: String) -> Int {
        var freeDay = 0
        if let subcription = InappManager.share.listProduct.first(where: {$0.productIdentifier == id})?.introductoryPrice?.subscriptionPeriod {
            switch subcription.unit {
            case .day:
                freeDay = subcription.numberOfUnits
            case .week:
                freeDay = subcription.numberOfUnits * 7
            default:
                freeDay = 3
            }
        }
        return freeDay
    }
    
    func checkPurchaseProduct() {
        SwiftyStoreKit.completeTransactions(atomically: true) { [weak self] purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    self?.purchasedProduct = IAPIdType.allCases.filter({ $0.id == purchase.productId }).first
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func purchaseProduct(withId id: String) {
        ProgressHUD.show()
        
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { [weak self] result in
            ProgressHUD.hide()
            switch result {
            case .success(let purchase):
                self?.purchasedProduct = IAPIdType.allCases.filter({ $0.id == purchase.productId }).first
                UserDefaults.standard.isUserVip = true
                self?.delegate?.purchaseSuccess(id: purchase.productId)
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction) // kết thúc dao dịch
                }
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Unknown error. Please contact support")
                case .clientInvalid:
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    print("Not allowed to make the payment")
                case .paymentInvalid:
                    print("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                default:
                    break
                }
            }
        }
    }
    
    func productInfo(id: Set<String>, isShowLoading: Bool = true, completed: @escaping(Set<SKProduct>) -> () = {_ in}) {
        if isShowLoading {
            ProgressHUD.show()
        }
        SwiftyStoreKit.retrieveProductsInfo(id) { [weak self] result in
            ProgressHUD.hide()
            if !result.retrievedProducts.isEmpty {
                self?.listProduct = result.retrievedProducts
                self?.productsInfo.send(result.retrievedProducts)
                DispatchQueue.main.async {
                    completed(result.retrievedProducts)
                }
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
                DispatchQueue.main.async {
                    completed([])
                }
            }
            else {
                print("Error: \(result.error!)")
                DispatchQueue.main.async {
                    completed([])
                }
            }
        }
        
    }
    
    // MARK: Restore
    func restorePurchases(isShowLoading: Bool = true, completed: @escaping() -> () = {}) {
        if isShowLoading {
            ProgressHUD.show()
        }
        
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
            
            guard let _self = self else {return}
            if results.restoreFailedPurchases.count > 0 {
                UserDefaults.standard.isUserVip = false
                ProgressHUD.hide()
                completed()
            }
            else if results.restoredPurchases.count > 0 {
                let appleValidator = AppleReceiptValidator(service: Constants.isDev ? .sandbox : .production, sharedSecret: _self.sharedSecret)
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                    ProgressHUD.hide()
                    switch result {
                    case .success(let receipt):
                        
                        
                        let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: _self.productIdentifiers, inReceipt: receipt)
                        
                        
                        switch purchaseResult {
                        case .purchased( _, let items):
                            self?.infoPurchaseProduct = items.first
                            self?.purchasedProduct = IAPIdType.allCases.filter({ $0.id == items[0].productId }).first
                            UserDefaults.standard.isUserVip = true
                            _self.delegate?.purchaseSuccess(id: "")
                            completed()
                        case .expired(_,_):
                            UserDefaults.standard.isUserVip = false
                            completed()
                        case .notPurchased:
                            UserDefaults.standard.isUserVip = false
                            completed()
                            break
                        }
                        
                        
                    case .error(let error):
                        completed()
                        print("verify faild \(error.localizedDescription)")
                        
                    }
                }
            }
            else {
                completed()
                ProgressHUD.hide()
                UserDefaults.standard.isUserVip = false
            }
        }
    }
    
    // MARK: Tự động Gia hạn
    func veryCheckRegisterPack(completed: @escaping() -> ()) {
        let appleValidator = AppleReceiptValidator(service: Constants.isDev ? .sandbox : .production , sharedSecret: self.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: self.productIdentifiers, inReceipt: receipt)
                switch purchaseResult {
                case .purchased( let expireddate, let items):
                    print("==> purchased expireddate \(expireddate)")
                    UserDefaults.standard.isUserVip = true
                    self.infoPurchaseProduct = items.first
                    self.purchasedProduct = IAPIdType.allCases.filter({ $0.id == items[0].productId }).first
                case .expired(let expireddate,_):
                    print("==> expireddate \(expireddate)")
                    UserDefaults.standard.isUserVip = false
                case .notPurchased:
                    UserDefaults.standard.isUserVip = false
                }
                completed()
            case .error(_):
                UserDefaults.standard.isUserVip = false
                completed()
            }
            
        }
    }
    
    func getInfoPurchasedProduct() {
        let appleValidator = AppleReceiptValidator(service: Constants.isDev ? .sandbox : .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true) { result in
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: self.productIdentifiers, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(_, let items):
                    self.infoPurchaseProduct = items.first
                default:
                    break
                }
            case .error(let error):
                print("Verify receipt failed: \(error)")
            }
        }
    }
    
}

extension SKProduct {
    
    /// - returns: The cost of the product formatted in the local currency.
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
    
}
