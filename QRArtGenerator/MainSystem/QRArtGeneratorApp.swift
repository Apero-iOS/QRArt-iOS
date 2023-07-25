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
import FacebookCore
import Adjust
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configAdjust()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        AdServices.shared.fetchAttributionData()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app,
                                               open: url,
                                               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                               annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}

@main
struct QRArtGeneratorApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        setupFirebase()
        configTableView()
        configScrollView()
        configKeyboard()
        configIAP()
        resetUserDefaults()
        setUpAds()
        configNavigationBar()
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
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30
    }
    
    private func configIAP() {
        InappManager.share.checkPurchaseProduct()
        InappManager.share.productInfo(id: InappManager.share.productIdentifiers, isShowLoading: false)
    }
    
    private func configNavigationBar() {
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.backgroundColor = .white
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: R.color.color_1B232E()!, .font: R.font.urbanistSemiBold(size: 18)!]
        coloredNavAppearance.shadowColor = .clear
        coloredNavAppearance.setBackIndicatorImage(R.image.ic_arrow_back()?.withRenderingMode(.alwaysOriginal), transitionMaskImage: R.image.ic_arrow_back()?.withRenderingMode(.alwaysOriginal))
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
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
        AdMobManager.shared.adsNativeColor = Constants.Colors.defaultNativeAdColors
        
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

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
