//
//  SliderSettingView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import SwiftUI

enum SliderSettingType {
    case guidance
    case step
}

struct SliderSettingView: View {
    var title: String = ""
    var desc: String = ""
    @Binding var value: Double
    @State var fromValue: Int = 1
    @State var toValue: Int = 10
    var type = SliderSettingType.guidance
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistSemiBold.font(size: 14))
            Text(desc)
                .foregroundColor(R.color.color_6A758B.color)
                .font(R.font.urbanistMedium.font(size: 12))
            HStack(spacing: 8) {
                Slider(value: $value, in: Double(fromValue)...Double(toValue), step: 1.0)
                    .setColorSlider(color: R.color.color_653AE4.color)
                    .onAppear {
                        UISlider.appearance()
                            .setThumbImage(UIImage(named: "ic_tint_slider"), for: .normal)
                    }
                    .onChange(of: value) { newValue in
                        switch type {
                        case .guidance:
                            FirebaseAnalytics.logEvent(type: .advanced_setting_guidance_click)
                        case .step:
                            FirebaseAnalytics.logEvent(type: .advanced_setting_step_click)
                        }
                    }
                
                Text("\(Int(value))")
                    .font(R.font.urbanistSemiBold.font(size: 14))
                    .foregroundColor(R.color.color_1B232E.color)
            }
            
        }
    }
}

struct SliderSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SliderSettingView(value: .constant(1))
    }
}
