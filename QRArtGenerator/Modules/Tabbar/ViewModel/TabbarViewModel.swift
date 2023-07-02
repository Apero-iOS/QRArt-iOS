//
//  TabbarViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI

class TabbarViewModel: ObservableObject {
    @Published var selectedTab: TabbarEnum = .home
    @Published var showScan: Bool = false
    @Published var showCreateQR: Bool = false
    @Published var showIAP: Bool = false

    var tabs: [TabbarEnum] = TabbarEnum.allCases
}
