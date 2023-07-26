//
//  DetailStylesViewModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 02/07/2023.
//

import Foundation
import SwiftUI
import MobileAds

final class DetailStylesViewModel: ObservableObject, Identifiable {
    
    @Published var isLoadAdsSuccess: Bool = true
    @Published var selection: Int? = nil
    
    var isShowAdsBanner: Bool {
        return RemoteConfigService.shared.bool(forKey: .banner_tab_bar) && !UserDefaults.standard.isUserVip
    }
    
    public func getColumns() -> [GridItem] {
        let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        return columns
    }
    
}
