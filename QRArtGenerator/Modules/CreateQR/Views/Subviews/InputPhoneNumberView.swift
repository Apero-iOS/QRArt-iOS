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
    @State var name: String = ""
    @Binding var showingSelectCountryView: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(Rlocalizable.phone_number())
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistMedium.font(size: 14))
            HStack {
                HStack(spacing: 8) {
                    type.image
                        .shadow(color: type.shadowColor, radius: type.radiusShadow, x: type.positionShadow.x, y: type.positionShadow.y)
                    Image(R.image.ic_dropdown)
                }
                .frame(maxHeight: 42, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                .onTapGesture {
                    showingSelectCountryView = true
                }
                TextField(placeholder, text: $name)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                    .frame(maxHeight: 42)
                    .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                    .font(R.font.urbanistRegular.font(size: 14))
                    .foregroundColor(R.color.color_6A758B.color)
            }
            
        }
    }
}

struct InputPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        InputPhoneNumberView(showingSelectCountryView: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
