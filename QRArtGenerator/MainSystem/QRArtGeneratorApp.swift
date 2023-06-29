//
//  QRArtGeneratorApp.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import SwiftUI

@main
struct QRArtGeneratorApp: App {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
    }
        
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
