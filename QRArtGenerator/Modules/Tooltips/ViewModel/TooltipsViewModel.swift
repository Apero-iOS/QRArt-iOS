//
//  TooltipsViewModel.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 25/07/2023.
//

import Foundation
import SwiftUI

class TooltipsViewModel: ObservableObject {
    
    @Published var opacity: Double = 0
    
    func getBottomPadding(_ isShowAdBanner: Bool, safeArea: EdgeInsets) -> CGFloat {
        return isShowAdBanner ? (safeArea.bottom + 50) : safeArea.bottom
    }
    
}
