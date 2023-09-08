//
//  EmailDescriptionView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import SwiftUI

struct DescriptionView: View {
    var title: String = ""
    @State var placeHolder: String = ""
    @Binding var desc: String
    @Binding var validInput: Bool
    var focusField: FocusState<TextFieldType?>.Binding
    var textfieldType: TextFieldType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
                .foregroundColor(R.color.color_1B232E.color)
            
            ZStack {
                if desc.isEmpty {
                    TextEditor(text: $placeHolder)
                        .frame(height: 200, alignment: .top)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .border(radius: 12, color: getBorderColor(), width: 1)
                        .font(R.font.beVietnamProRegular.font(size: 14))
                        .foregroundColor(R.color.color_6A758B.color)
                        .disabled(true)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $desc)
                    .focused(focusField, equals: textfieldType)
                    .frame(height: 200, alignment: .top)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .border(radius: 12, color: getBorderColor(), width: 1)
                    .font(R.font.beVietnamProRegular.font(size: 14))
                    .foregroundColor(R.color.color_1B232E.color)
                    .opacity(desc.isEmpty ? 0.25 : 1)
            }

            
            if validInput && desc.isEmptyOrWhitespace() {
                Text(Rlocalizable.cannot_be_empty)
                    .foregroundColor(R.color.color_BD1E1E.color)
                    .font(R.font.beVietnamProRegular.font(size: 14))
            }
        }
    }
    
    func getBorderColor() -> Color {
        if validInput && desc.isEmptyOrWhitespace() {
            return R.color.color_BD1E1E.color
        } else {
            if focusField.wrappedValue == textfieldType {
                return R.color.color_653AE4.color
            } else {
                return R.color.color_EAEAEA.color
            }
        }
    }
}

struct EmailDescriptionView_Previews: PreviewProvider {
    @FocusState static var focusState: TextFieldType?
    
    static var previews: some View {
        DescriptionView(desc: .constant(""), validInput: .constant(true), focusField: $focusState,
                        textfieldType: .emailDesc)
    }
}
