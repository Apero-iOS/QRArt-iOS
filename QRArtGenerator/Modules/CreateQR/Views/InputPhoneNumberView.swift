//
//  InputPhoneNumberView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import SwiftUI

struct InputPhoneNumberView: View {
    var title: String = "Name"
    var placeholder: String = "Input your Name"
    @State var name: String = ""
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text("Phone Number")
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistMedium.font(size: 14))
            TextField(placeholder, text: $name)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .frame(maxHeight: 42)
                .border(R.color.color_EAEAEA.color, width: 0.5)
                .cornerRadius(8)
        }
    }
}

struct InputPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InputPhoneNumberView()
                .previewLayout(.sizeThatFits)
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
                .previewDisplayName("iPhone 14")
            InputPhoneNumberView()
                .previewLayout(.sizeThatFits)
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
        }

    }
}
