//
//  PromptView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import SwiftUI
import MobileAds

enum PromptViewType {
    case prompt
    case negativePrompt
}

struct PromptView: View {
    var oldPrompt: String
    var title: String = ""
    var subTitle: String = ""
    @State var countAds: Int = 1
    @State var typePrompt: PromptViewType = .prompt
    @Binding var prompt: String
    @Binding var validInput: Bool
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(R.font.urbanistSemiBold.font(size: 14))
                        .foregroundColor(R.color.color_1B232E.color)
                    Text(subTitle)
                        .font(R.font.urbanistMedium.font(size: 12))
                        .foregroundColor(R.color.color_6A758B.color)
                }
                Spacer()
                Button {
                    prompt = oldPrompt
                } label: {
                    R.image.ic_pen.image
                }
            }
            TextField(Rlocalizable.enter_prompt(), text: $prompt)
                .frame(height: 100, alignment: .top)
                .focused($isFocused)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .border(radius: 12, color: getBorderColor(), width: 1)
                .font(R.font.urbanistRegular.font(size: 14))
            if validInput && typePrompt == .prompt && prompt.isEmpty {
                Text(Rlocalizable.cannot_be_empty)
                    .foregroundColor(R.color.color_BD1E1E.color)
                    .font(R.font.urbanistRegular.font(size: 14))
            }
        }
    }
    
    func getBorderColor() -> Color {
        if validInput && typePrompt == .prompt && prompt.isEmpty {
            return R.color.color_BD1E1E.color
        } else {
            if isFocused {
                return R.color.color_653AE4.color
            } else {
                return R.color.color_EAEAEA.color
            }
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView(oldPrompt: "", prompt: .constant(""), validInput: .constant(false))
    }
}
