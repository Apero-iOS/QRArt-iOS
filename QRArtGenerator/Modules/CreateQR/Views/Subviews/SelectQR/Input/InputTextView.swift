//
//  InputNameView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import SwiftUI

enum InputTextViewType {
    case url
    case name
}

struct InputTextView: View {
    var title: String = ""
    var placeholder: String = ""
    @State var type: InputTextViewType = .name
    @Binding var name: String
    @Binding var validInput: Bool
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistMedium.font(size: 14))
            textField
            if validInput && name.isEmptyOrWhitespace() {
                textError(text: Rlocalizable.cannot_be_empty())
            } else if validInput && type == .url && !name.isValidUrl() {
                textError(text: Rlocalizable.invalid_url())
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
        if (validInput && name.isEmptyOrWhitespace()) || (validInput && type == .url && !name.isValidUrl()) {
            return R.color.color_BD1E1E.color
        } else {
            return setColorFocus()
        }
    }
    
    private func setColorFocus() -> Color {
        return isFocused ? R.color.color_653AE4.color : R.color.color_EAEAEA.color
    }
    
    func textError(text: String) -> some View {
        Text(text)
            .foregroundColor(R.color.color_BD1E1E.color)
            .font(R.font.urbanistRegular.font(size: 14))
    }
}

struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        InputTextView(name: .constant(""), validInput: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
