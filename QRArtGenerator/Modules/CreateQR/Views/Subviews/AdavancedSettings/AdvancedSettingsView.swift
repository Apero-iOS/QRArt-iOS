//
//  AdvancedSettingsView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import SwiftUI

enum AdvancedSettingsMode {
    case expand
    case collapse
}

struct AdvancedSettingsView: View {
    @Binding var mode: AdvancedSettingsMode
    @Binding var rotate: Double
    var didTapExpand: ((AdvancedSettingsMode) -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Rlocalizable.advanced_settings())
                        .font(R.font.urbanistSemiBold.font(size: 16))
                        .foregroundColor(R.color.color_1B232E.color)
                    Text(Rlocalizable.advanced_settings_sub_title)
                        .font(R.font.urbanistMedium.font(size: 12))
                        .foregroundColor(R.color.color_6A758B.color)
                }
                Spacer()
                
                image.rotationEffect(.degrees(rotate))
            }
            .background(Color.white)
            .onTapGesture {
                FirebaseAnalytics.logEvent(type: .advanced_setting_view)
                UIApplication.shared.endEditing()
                if mode == .expand {
                    withAnimation(.easeIn(duration: 0.2)) {
                        rotate = 0
                        didTapExpand?(.collapse)
                    }
                } else {
                    withAnimation(.easeOut(duration: 0.1)) {
                        rotate = 90
                        didTapExpand?(.expand)
                    }
                }
            }
        }
        .clearBackgroundColorList()
        .padding(.horizontal, 20)
        
    }
    
    @ViewBuilder var image: some View {
        R.image.ic_left.image
            .frame(width: 24, height: 24)
    }
}
