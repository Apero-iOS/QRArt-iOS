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
    @State var mode: AdvancedSettingsMode = .collapse
    @State var rotate: Double = 0
    @Binding var negativePromt: String
    @Binding var positivePrompt: String
    @Binding var oldNegativePromt: String
    @Binding var oldPositivePrompt: String

    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Text(Rlocalizable.advanced_settings())
                    .font(R.font.urbanistSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                Spacer()
                Button {
                    if mode == .expand {
                        withAnimation {
                            mode = .collapse
                        }
                        rotate = 0
                    } else {
                        withAnimation {
                            mode = .expand
                        }
                        rotate = 90
                    }
                } label: {
                    image.rotationEffect(.degrees(rotate))
                }
            }
            if mode == .expand {
                descView
            }
        }
        .clearBackgroundColorList()
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
    }
    
    @ViewBuilder var descView: some View {
        VStack {
            PromptView(prompt: $negativePromt,
                       oldPrompt: oldNegativePromt,
                       title: Rlocalizable.prompt(),
                       subTitle: Rlocalizable.prompt_desc())
            PromptView(prompt: $positivePrompt,
                       oldPrompt: oldPositivePrompt,
                       title: Rlocalizable.negative_prompt(),
                       subTitle: Rlocalizable.negative_prompt_desc())
            SliderSettingView(title: Rlocalizable.guidance(),
                              desc: Rlocalizable.guidance_desc())
            SliderSettingView(title: Rlocalizable.controlnet_scale(),
                              desc: Rlocalizable.controlnet_scale_desc())
            SliderSettingView(title: Rlocalizable.steps(),
                              desc: Rlocalizable.steps_desc())
        }
    }
    
    @ViewBuilder var image: some View {
        R.image.ic_left.image
            .frame(width: 24, height: 24)
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView(negativePromt: .constant(""), positivePrompt: .constant(""), oldNegativePromt: .constant(""), oldPositivePrompt: .constant(""))
    }
}
