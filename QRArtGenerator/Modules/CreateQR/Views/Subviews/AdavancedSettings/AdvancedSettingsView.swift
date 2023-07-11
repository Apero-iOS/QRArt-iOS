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
    @State var rotate: Double = 0
    @Binding var prompt: String
    @Binding var negativePrompt: String
    @Binding var oldPrompt: String
    @Binding var oldNegativePrompt: String
    @Binding var guidance: Double
    @Binding var steps: Double
    @Binding var scale: Double
    @Binding var validInput: Bool

    var body: some View {
        VStack(spacing: 16) {
            LazyVStack(alignment: .leading) {
                HStack {
                    VStack(spacing: ) {
                        Text(Rlocalizable.advanced_settings())
                            .font(R.font.urbanistSemiBold.font(size: 16))
                            .foregroundColor(R.color.color_1B232E.color)
                        Text(Rlocalizable.advanced_settings_sub_title)
                            .font(R.font.urbanistMedium.font(size: 12))
                            .foregroundColor(R.color.color_6A758B.color)
                    }
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
            R.color.color_F7F7F7.color
                .frame(height: 45)
        }

    }
    
    @ViewBuilder var descView: some View {
        VStack {
            // prompt
            PromptView(prompt: $prompt,
                       oldPrompt: oldPrompt,
                       title: Rlocalizable.prompt(),
                       subTitle: Rlocalizable.prompt_desc(),
                       validInput: $validInput)
            // negative prompt
            PromptView(prompt: $negativePrompt,
                       oldPrompt: oldNegativePrompt,
                       title: Rlocalizable.negative_prompt(),
                       subTitle: Rlocalizable.negative_prompt_desc(),
                       validInput: $validInput)
            // guidance
            SliderSettingView(title: Rlocalizable.guidance(),
                              desc: Rlocalizable.guidance_desc(),
                              value: $guidance)
            // scale
            SliderSettingView(title: Rlocalizable.controlnet_scale(),
                              desc: Rlocalizable.controlnet_scale_desc(),
                              value: $scale)
            // steps
            SliderSettingView(title: Rlocalizable.steps(),
                              desc: Rlocalizable.steps_desc(),
                              value: $steps)
        }
    }
    
    @ViewBuilder var image: some View {
        R.image.ic_left.image
            .frame(width: 24, height: 24)
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView(mode: .constant(.collapse), prompt: .constant(""),
                             negativePrompt: .constant(""),
                             oldPrompt: .constant(""),
                             oldNegativePrompt: .constant(""), guidance: .constant(0), steps: .constant(0), scale: .constant(0), validInput: .constant(false))
    }
}
