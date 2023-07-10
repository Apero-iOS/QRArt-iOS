//
//  InputPhoneNumberView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import SwiftUI

struct InputPhoneNumberView: View {
    var title: String = ""
    var placeholder: String = ""
    var type: QRType = .contact
    @Binding var phoneNumber: String
    @Binding var showingSelectCountryView: Bool
    @Binding var validInput: Bool
    @Binding var country: Country
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(Rlocalizable.phone_number())
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistMedium.font(size: 14))
            HStack(alignment: .top) {
                HStack(spacing: 8) {
                    AsyncImage(url: country.flagUrl)
                        .frame(width: 24, height: 24)
                        .cornerRadius(12)
                    Image(R.image.ic_dropdown)
                }
                .frame(maxHeight: 42, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                .onTapGesture {
                    showingSelectCountryView = true
                }
                VStack(alignment: .leading, spacing: 8) {
                    TextField(country.dialCode, text: $phoneNumber)
                        .focused($isFocused)
                        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                        .frame(maxHeight: 42)
                        .border(radius: 12, color: getBorderColor(), width: 1)
                        .font(R.font.urbanistRegular.font(size: 14))
                        .foregroundColor(R.color.color_1B232E.color)
                        .keyboardType(.decimalPad)
                    if validInput && phoneNumber.isEmptyOrWhitespace() {
                        Text(Rlocalizable.cannot_be_empty)
                            .foregroundColor(R.color.color_BD1E1E.color)
                            .font(R.font.urbanistRegular.font(size: 14))
                    }
                }
            }
        }
    }
    
    func getBorderColor() -> Color {
        if validInput && phoneNumber.isEmptyOrWhitespace() {
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

struct InputPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        InputPhoneNumberView(phoneNumber: .constant(""), showingSelectCountryView: .constant(true), validInput: .constant(true), country: .constant(Country(code: "VN", dialCode: "+84")))
            .previewLayout(.sizeThatFits)
    }
}
