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
    var focusField: FocusState<TextFieldType?>.Binding
    var textfieldType: TextFieldType
    var didTap: VoidBlock?
    let maxLength: Int = 500
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(R.font.urbanistSemiBold.font(size: 14))
                        .foregroundColor(R.color.color_1B232E.color)
                    HStack {
                        Text(subTitle)
                            .font(R.font.urbanistMedium.font(size: 12))
                            .foregroundColor(R.color.color_6A758B.color)
                        Spacer()
                        if !prompt.isEmpty {
                            Button {
                                prompt = ""
                            } label: {
                                Text(Rlocalizable.reset())
                                    .font(R.font.urbanistMedium.font(size: 12))
                                    .foregroundColor(R.color.color_1B232E.color)
                            }
                        }
                    }
                }
            }
            ZStack {
                if prompt.isEmpty {
                    VStack(spacing: 8) {
                        TextEditor(text: .constant(Rlocalizable.enter_prompt()))
                            .frame(height: 120, alignment: .top)
                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                            
                            .font(R.font.urbanistRegular.font(size: 14))
                            .foregroundColor(R.color.color_6A758B.color)
                            .allowsHitTesting(false)
                        textCountPrompt
                    }
                    .border(radius: 12, color: getBorderColor(), width: 1)
                    
                }
                VStack(spacing: 8) {
                    TextEditor(text: $prompt)
                        .frame(height: 120, alignment: .top)
                        .focused(focusField, equals: textfieldType)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                        
                        .font(R.font.urbanistRegular.font(size: 14))
                        .foregroundColor(R.color.color_1B232E.color)
                        .opacity(prompt.isEmpty ? 0.25 : 1)
                        .onChange(of: prompt) { newValue in
                            if newValue.count > maxLength {
                                prompt = String(newValue.prefix(maxLength))
                            }
                        }
                    textCountPrompt
                }
                .border(radius: 12, color: getBorderColor(), width: 1)

            }
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
            if focusField.wrappedValue == textfieldType {
                return R.color.color_653AE4.color
            } else {
                return R.color.color_EAEAEA.color
            }
        }
    }
    
    @ViewBuilder var textCountPrompt: some View {
        HStack(spacing: 0) {
            Text("\(prompt.count)/")
                .font(R.font.urbanistMedium.font(size: 12))
                .foregroundColor(getColorCountText(type: .count))
            Text("\(maxLength)")
                .font(R.font.urbanistMedium.font(size: 12))
                .foregroundColor(getColorCountText(type: .limit))
            Spacer()
            Button {
                didTap?()
                FirebaseAnalytics.logEvent(type: typePrompt == .prompt ? .advanced_suggest_prompt_click : .advanced_suggest_negative_prompt_click)
            } label: {
                R.image.ic_random_prompt.image
            }
        }
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 8, trailing: 12))
    }
    
    enum TextCount {
        case count
        case limit
    }
    
    func getColorCountText(type: TextCount) -> Color {
        if prompt.isEmpty || prompt.count >= maxLength {
            return R.color.color_BD1E1E.color
        }
        switch type {
        case .count:
            return R.color.color_1B232E.color
        case .limit:
            return R.color.color_6A758B.color
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    @FocusState static var focusState: TextFieldType?
    
    static var previews: some View {
        PromptView(oldPrompt: "", prompt: .constant(""), validInput: .constant(false), focusField: $focusState,
                   textfieldType: .prompt)
    }
}
