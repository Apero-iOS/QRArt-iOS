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
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().showsHorizontalScrollIndicator = false
        UITableView.appearance().separatorStyle = .none
    }
        
    var body: some Scene {
        WindowGroup {
            CreateQRView()
        }
    }
}
