//
//  View+.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI
import UIKit

extension View {
    @ViewBuilder func hideNavigationBar() -> some View {
        if #available(iOS 16, *) {
            toolbar(.hidden)
        } else {
            navigationBarHidden(true)
        }
    }
    
    @ViewBuilder func border(radius: CGFloat, color: Color, width: CGFloat) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .inset(by: 0.5)
                .stroke(color, lineWidth: width))
    }
    
    @ViewBuilder func clearBackgroundColorList() -> some View {
        if #available(iOS 16, *) {
            scrollContentBackground(.hidden)
        } else {
            UITableView.appearance().backgroundColor = .clear
            return background(Color.clear)
        }
    }
}
