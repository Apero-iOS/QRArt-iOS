//
//  InputNameView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import SwiftUI

struct InputNameView: View {
    var title: String = ""
    var placeholder: String = ""
    @Binding var name: String
    @Binding var validInput: Bool
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistMedium.font(size: 14))
            textField
            if validInput && name.isEmpty {
                Text(Rlocalizable.cannot_be_empty)
                    .foregroundColor(R.color.color_BD1E1E.color)
                    .font(R.font.urbanistRegular.font(size: 14))
            }
        }
    }
    
    @ViewBuilder var textField: some View {
        TextField(placeholder, text: $name)
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            .frame(maxHeight: 42)
            .focused($isFocused)
            .border(radius: 12, color: getBorderColor(),
                    width: 1)
            .font(R.font.urbanistRegular.font(size: 14))
            .foregroundColor(R.color.color_1B232E.color)
    }
    
    func getBorderColor() -> Color {
        if validInput && name.isEmpty {
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

struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        InputNameView(name: .constant(""), validInput: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
