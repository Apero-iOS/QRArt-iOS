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
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Text("Advanced Settings")
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
            PromptView()
            PromptView()
            SliderSettingView(title: "Guidance", desc: "Show the influence of prompts on image generation.")
            SliderSettingView(title: "ControNet scale", desc: "ControNet scale measures the ability of an AI generation system to produce outputs with higher levels of co ntrol.")
            SliderSettingView(title: "Steps", desc: "The number of steps required to generate an image. The higher steps, the more quality.")
        }
    }
    
    @ViewBuilder var image: some View {
        R.image.ic_left.image
            .frame(width: 24, height: 24)
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
    }
}
