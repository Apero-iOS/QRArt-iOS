//
//  AmountView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

struct AmountView: View {
    @Binding var amount: String
    @Binding var validInput: Bool
    var focusField: FocusState<TextFieldType?>.Binding
    var textfieldType: TextFieldType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Rlocalizable.amount)
                .font(R.font.beVietnamProSemiBold.font(size: 14))
                .foregroundColor(R.color.color_1B232E.color)
            TextField(text: $amount) {
                Text("$")
                    .foregroundColor(R.color.color_1B232E.color)
                    .font(R.font.beVietnamProRegular.font(size: 14))
            }
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            .frame(height: 42)
            .focused(focusField, equals: textfieldType)
            .border(radius: 12, color: getBorderColor(),
                    width: 1)
            .keyboardType(.decimalPad)
            if validInput && amount.isEmptyOrWhitespace() {
                textError(text: Rlocalizable.cannot_be_empty())
            } else if validInput && !isValidNumber() {
                Text(Rlocalizable.valid_amount)
                    .foregroundColor(R.color.color_BD1E1E.color)
                    .font(R.font.beVietnamProRegular.font(size: 14))
            }
            
        }
    }
    func getBorderColor() -> Color {
        if validInput && (amount.isEmptyOrWhitespace() || !isValidNumber()) {
            return R.color.color_BD1E1E.color
        } else {
            if focusField.wrappedValue == textfieldType {
                return R.color.color_653AE4.color
            } else {
                return R.color.color_EAEAEA.color
            }
        }
    }
    
    func textError(text: String) -> some View {
        Text(text)
            .foregroundColor(R.color.color_BD1E1E.color)
            .font(R.font.beVietnamProRegular.font(size: 14))
    }
    
    func isValidNumber() -> Bool {
        return Int(amount) != nil
    }
}

struct AmountView_Previews: PreviewProvider {
    @FocusState static var focusState: TextFieldType?
    
    static var previews: some View {
        AmountView(amount: .constant("$"), validInput: .constant(false), focusField: $focusState,
                   textfieldType: .paypal)
    }
}
