//
//  TabbarViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI

class TabbarViewModel: ObservableObject {
    @Published var selectedTab: TabbarEnum = .home
    
    var tabs: [TabbarEnum] = TabbarEnum.allCases
}
