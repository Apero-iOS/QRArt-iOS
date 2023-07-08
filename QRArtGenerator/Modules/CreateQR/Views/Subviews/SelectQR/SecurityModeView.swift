//
//  SecurityModeView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import SwiftUI

struct SecurityModeView: View {
    @Binding var wifiModeSelect: Int
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(Rlocalizable.security_mode())
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistMedium.font(size: 14))
            Picker(selection: $wifiModeSelect, label: Text(Rlocalizable.picker())) {
                ForEach(WifiSecurityMode.allCases, id: \.self) { mode in
                    textDesc(text: mode.title).tag(mode.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder func textDesc(text: String) -> some View {
        Text(text)
            .font(R.font.urbanistSemiBold.font(size: 12))
            .foregroundColor(Color.black)
    }
}

struct SecurityModeView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityModeView(wifiModeSelect: .constant(1))
    }
}
