//
//  EmailDescriptionView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import SwiftUI

struct DescriptionView: View {
    var title: String = ""
    var placeHolder: String = ""
    @Binding var desc: String
    @Binding var validInput: Bool
    @FocusState var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(R.font.urbanistSemiBold.font(size: 14))
                .foregroundColor(R.color.color_1B232E.color)
            TextField(placeHolder, text: $desc)
                .focused($isFocused)
                .frame(height: 200, alignment: .top)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .border(radius: 12, color: getBorderColor(), width: 1)
                .font(R.font.urbanistRegular.font(size: 14))
                .foregroundColor(R.color.color_1B232E.color)
                .onChange(of: desc) { newValue in
                    if newValue.count > 50 {
                        desc = String(newValue.prefix(50))
                    }
                }
            
            if validInput && desc.isEmptyOrWhitespace() {
                Text(Rlocalizable.cannot_be_empty)
                    .foregroundColor(R.color.color_BD1E1E.color)
                    .font(R.font.urbanistRegular.font(size: 14))
            }
        }
    }
    
    func getBorderColor() -> Color {
        if validInput && desc.isEmptyOrWhitespace() {
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

struct EmailDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(desc: .constant(""), validInput: .constant(true))
    }
}
