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

class InappManager: NSObject {
    
    static let share = InappManager()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    let sharedSecret: String = "81440b93fc6e449fa826be9551a0d343"
    let productIdentifiers: Set<ProductIdentifier> = Set(IAPIdType.allCases.compactMap{$0.id})
    var listProduct = Set<SKProduct>()
    var didPaymentSuccess = PassthroughSubject<Bool, Never>()
    var productsInfo = CurrentValueSubject<Set<SKProduct>, Never>([])
    var purchasedProduct: IAPIdType?
    var infoPurchaseProduct: ReceiptItem?
    private var needShowRestoreError = false
    weak var delegate: InappManagerDelegate?
    
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
        guard let product = listProduct.first(where: { $0.productIdentifier == id }) else { return }
        if SKPaymentQueue.canMakePayments() {
            ProgressHUD.show()
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
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
    func restorePurchases(isShowLoading: Bool = true) {
        if (SKPaymentQueue.canMakePayments()) {
            if isShowLoading {
                ProgressHUD.show()
            }
            needShowRestoreError = isShowLoading
            SKPaymentQueue.default().restoreCompletedTransactions()
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
            case .error:
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

// MARK: - SKPaymentTransactionObserver
extension InappManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                ProgressHUD.hide()
                purchasedProduct = IAPIdType.allCases.filter({ $0.id == transaction.payment.productIdentifier }).first
                UserDefaults.standard.isUserVip = true
                SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
            case .failed:
                print("Purchased Failed")
                ProgressHUD.hide()
                SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if needShowRestoreError {
            AppHelper.getRootViewController()?.view.makeToast(error.localizedDescription)
        }
        ProgressHUD.hide()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let appleValidator = AppleReceiptValidator(service: Constants.isDev ? .sandbox : .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] result in
            ProgressHUD.hide()
            guard let self = self else { return }
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: self.productIdentifiers, inReceipt: receipt)
                switch purchaseResult {
                case .purchased( _, let items):
                    self.infoPurchaseProduct = items.first
                    self.purchasedProduct = IAPIdType.allCases.filter({ $0.id == items[0].productId }).first
                    UserDefaults.standard.isUserVip = true
                    self.delegate?.purchaseSuccess(id: "")
                case .expired(_,_):
                    UserDefaults.standard.isUserVip = false
                case .notPurchased:
                    UserDefaults.standard.isUserVip = false
                    break
                }
            case .error(let error):
                print("verify faild \(error.localizedDescription)")
            }
        }
        for transaction in queue.transactions {
            SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
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
