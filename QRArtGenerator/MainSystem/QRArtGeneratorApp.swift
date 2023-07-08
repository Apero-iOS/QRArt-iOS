//
//  QRArtGeneratorApp.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import SwiftUI
import IQKeyboardManagerSwift
import Firebase
import MobileAds

@main
struct QRArtGeneratorApp: App {
    
    init() {
        setupFirebase()
        configTableView()
        configScrollView()
        configKeyboard()
        configIAP()
        resetUserDefaults()
        setUpAds()
    }
        
    var body: some Scene {
        WindowGroup {
            SplashView()
        }

    }
    
    private func configTableView() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().showsHorizontalScrollIndicator = false
        UITableView.appearance().separatorStyle = .none
        UITabBar.appearance().isHidden = true
    }
    
    private func configScrollView() {
        UIScrollView.appearance().showsVerticalScrollIndicator = false
    }
    
    private func configKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    private func configIAP() {
        InappManager.share.checkPurchaseProduct()
        InappManager.share.productInfo(id: InappManager.share.productIdentifiers, isShowLoading: false)
    }
    
    func setupFirebase() {
        guard let plistPath = Bundle.main.path(forResource: Constants.GoogleService.ggPlistName, ofType: "plist"),
              let options = FirebaseOptions(contentsOfFile: plistPath)
        else {
            return
        }
        FirebaseApp.configure(options: options)
    }
    
    func setUpAds() {
        AdMobManager.shared.adFullScreenLoadingString = Rlocalizable.ad_is_loading()
        AdMobManager.shared.rewardErrorString = Rlocalizable.an_error_occurred()
    }
    
    func resetUserDefaults() {
        if let lastDate = UserDefaults.standard.lastDayOpenApp {
            let calendar = Calendar.current
            let firstComponents = calendar.dateComponents([.year, .month, .day], from: lastDate)
            let secondComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            if firstComponents.year == secondComponents.year &&
                firstComponents.month == secondComponents.month &&
                firstComponents.day == secondComponents.day {
                print("Ngày, tháng, năm của hai date giống nhau.")
            } else {
                print("Ngày, tháng, năm của hai date khác nhau.")
                UserDefaults.standard.generatePerDay = 0
                UserDefaults.standard.regeneratePerDay = 0
                UserDefaults.standard.lastDayOpenApp = Date()
            }
        } else {
            UserDefaults.standard.lastDayOpenApp = Date()
        }
    }
}
