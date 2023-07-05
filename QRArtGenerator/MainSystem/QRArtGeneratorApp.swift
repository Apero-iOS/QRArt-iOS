//
//  QRArtGeneratorApp.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import SwiftUI
import IQKeyboardManagerSwift
import Firebase

@main
struct QRArtGeneratorApp: App {
    
    init() {
        setupFirebase()
        configTableView()
        configScrollView()
        configKeyboard()
        configIAP()
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
}
