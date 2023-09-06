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
    var focusField: FocusState<TextFieldType?>.Binding
    var textfieldType: TextFieldType
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(Rlocalizable.phone_number())
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
            HStack(alignment: .top) {
                HStack(spacing: 8) {
                    
                    Text(country.flag)
                        .frame(width: 24, height: 24)
                        .font(R.font.beVietnamProRegular.font(size: 24))
                        .multilineTextAlignment(.center)
                    Image(R.image.ic_dropdown)
                }
                .frame(maxHeight: 42, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    showingSelectCountryView = true
                }
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .leading) {
                        if phoneNumber.isEmpty {
                            Text(country.dialCode)
                                .foregroundColor(R.color.color_6A758B.color)
                                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                                .font(R.font.beVietnamProRegular.font(size: 14))
                        }
                        TextField("", text: $phoneNumber)
                            .focused(focusField, equals: textfieldType)
                            .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                            .frame(maxHeight: 42)
                            .border(radius: 12, color: getBorderColor(), width: 1)
                            .font(R.font.beVietnamProRegular.font(size: 14))
                            .foregroundColor(R.color.color_1B232E.color)
                            .keyboardType(.decimalPad)
                    }
                    if validInput && phoneNumber.isEmptyOrWhitespace() {
                        Text(Rlocalizable.cannot_be_empty)
                            .foregroundColor(R.color.color_BD1E1E.color)
                            .font(R.font.beVietnamProRegular.font(size: 14))
                    } else if validInput && !phoneNumber.isValidPhone() {
                        Text(Rlocalizable.invalid_phone_number)
                            .foregroundColor(R.color.color_BD1E1E.color)
                            .font(R.font.beVietnamProRegular.font(size: 14))
                    }
                }
            }
        }
    }
    
    func getBorderColor() -> Color {
        if validInput && (phoneNumber.isEmptyOrWhitespace() || !phoneNumber.isValidPhone()) {
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

struct InputPhoneNumberView_Previews: PreviewProvider {
    @FocusState static var focusState: TextFieldType?
    
    static var previews: some View {
        InputPhoneNumberView(phoneNumber: .constant(""), showingSelectCountryView: .constant(true), validInput: .constant(true), country: .constant(Country(flag: "1", code: "VN", dialCode: "+84")), focusField: $focusState,
                             textfieldType: .contactPhone)
            .previewLayout(.sizeThatFits)
    }
}
