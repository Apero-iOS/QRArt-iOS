//
//  View+.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI
import UIKit

extension View {
    @ViewBuilder func hideNavigationBar(isHidden: Bool) -> some View {
        if #available(iOS 16, *) {
            toolbar(isHidden ? .hidden : .visible)
        } else {
            navigationBarHidden(isHidden)
        }
    }
    
    @ViewBuilder func border(radius: CGFloat, color: Color, width: CGFloat, inset: CGFloat = 0) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius)
                .inset(by: inset)
                .stroke(color, lineWidth: width))
        .cornerRadius(radius)
    }
    
    @ViewBuilder func clearBackgroundColorList() -> some View {
        if #available(iOS 16, *) {
            scrollContentBackground(.hidden)
        } else {
            onAppear()
        }
    }
    
    @ViewBuilder func hideSeparatorLine() -> some View {
        if #available(iOS 15, *) {
            listRowSeparator(.hidden)
        } else {
            onAppear()
        }
    }
    
    @ViewBuilder func hideScrollIndicator() -> some View {
        if #available(iOS 16.0, *) {
            scrollIndicators(.hidden)
        } else {
            onAppear {
                UIScrollView.appearance().showsVerticalScrollIndicator = false
            }
        }
    }
    
    @ViewBuilder func setColorSlider(color: Color) -> some View {
        if #available(iOS 16, *) {
            tint(color)
        } else {
            accentColor(color)
        }
    }
    
    @ViewBuilder func disableScroll() -> some View {
        if #available(iOS 16, *) {
            scrollDisabled(true)
        } else {
            onAppear {
                UITableView.appearance().isScrollEnabled = false
            }
        }
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    func toast(message: String,
               isShowing: Binding<Bool>,
               config: Toast.Config) -> some View {
        self.modifier(Toast(message: message,
                            isShowing: isShowing,
                            config: config))
    }
    
    func toast(message: String,
               isShowing: Binding<Bool>,
               duration: TimeInterval = 2,
               position: ToastPosition = .center) -> some View {
        self.modifier(Toast(message: message,
                            isShowing: isShowing,
                            config: .init(duration: duration, position: position)))
    }
    
    @ViewBuilder func presentationDetent() -> some View {
        if #available(iOS 16, *) {
            presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.visible)
        } else {
            onAppear()
        }
    }
    
}

extension View {
    @ViewBuilder func hiddenConditionally(isHidden: Binding<Bool>) -> some View {
        isHidden.wrappedValue ? self  :  self.hidden() as? Self
    }
}
