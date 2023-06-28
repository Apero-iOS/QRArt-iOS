//
//  View+.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

extension View {
    @ViewBuilder func hideNavigationBar() -> some View {
        if #available(iOS 16, *) {
            toolbar(.hidden)
        } else {
            navigationBarHidden(true)
        }
    }
}
