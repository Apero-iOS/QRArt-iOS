//
//  InputNameView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import SwiftUI
import Combine

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
  
    var focusField: FocusState<TextFieldType?>.Binding
    var textfieldType: TextFieldType
    var typeInput: QRType
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
            textField
            if validInput && name.isEmptyOrWhitespace() {
                textError(text: Rlocalizable.cannot_be_empty())
            } else if validInput && type == .url {
                if !name.validateURL().isValid {
                    textError(text: Rlocalizable.invalid_url())
                } else {
                    if  let baseUrl = typeInput.baseUrl, !name.lowercased().contains(baseUrl) {
                        textError(text: Rlocalizable.invalid_url())
                    }
                }
                
            }
        }
    }
    
    @ViewBuilder var textField: some View {
        ZStack(alignment: .leading) {
            if name.isEmpty {
                Text(placeholder)
                    .foregroundColor(R.color.color_6A758B.color)
                    .font(R.font.beVietnamProRegular.font(size: 14))
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            }
            TextField("", text: $name)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .frame(maxHeight: 42)
                .focused(focusField, equals: textfieldType)
                .border(radius: 12, color: getBorderColor(),
                        width: 1)
                .font(R.font.beVietnamProRegular.font(size: 14))
                .foregroundColor(R.color.color_1B232E.color)
        }
    }
    
    func getBorderColor() -> Color {
        if (validInput && name.isEmptyOrWhitespace()) || (validInput && type == .url && !name.validateURL().isValid) {
            return R.color.color_BD1E1E.color
        } else {
            return setColorFocus()
        }
    }
    
    private func setColorFocus() -> Color {
        return focusField.wrappedValue == textfieldType ? R.color.color_653AE4.color : R.color.color_EAEAEA.color
    }
    
    func textError(text: String) -> some View {
        Text(text)
            .foregroundColor(R.color.color_BD1E1E.color)
            .font(R.font.beVietnamProRegular.font(size: 14))
    }
}

struct InputNameView_Previews: PreviewProvider {
    @FocusState static var focusState: TextFieldType?
    
    static var previews: some View {
        InputTextView(name: .constant(""),
                      validInput: .constant(true),
                      focusField: $focusState,
                      textfieldType: .contactPhone, typeInput: .contact)
            .previewLayout(.sizeThatFits)
    }
}
