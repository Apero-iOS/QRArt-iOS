//
//  QRArtGeneratorApp.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import SwiftUI
import IQKeyboardManagerSwift

@main
struct QRArtGeneratorApp: App {
    
    init() {
        configTableView()
        configKeyboard()
        FileManagerUtil.shared.createFolder(folder: FileManagerUtil.shared.photoFolderName)
    }
        
    var body: some Scene {
        WindowGroup {
            TabbarView()
        }
    }
    
    private func configTableView() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().showsHorizontalScrollIndicator = false
        UITableView.appearance().separatorStyle = .none
    }
    
    private func configKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
