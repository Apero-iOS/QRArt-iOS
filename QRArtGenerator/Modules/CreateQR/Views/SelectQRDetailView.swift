//
//  SelectQRView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI
import BottomSheet

struct SelectQRDetailView: View {
    @State var name: String = ""
    @Binding var showingSelectQRTypeView: Bool
    var type: QRType
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(Rlocalizable.select_qr_type)
                    .font(R.font.urbanistSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                HStack(alignment: .center, spacing: 12) {
                    type.image
                        .shadow(color: type.shadowColor, radius: type.radiusShadow, x: type.positionShadow.x, y: type.positionShadow.y)
                    Text(type.title)
                        .font(R.font.urbanistMedium.font(size: 16))
                        .foregroundColor(R.color.color_1B232E.color)
                    Spacer()
                    if showingSelectQRTypeView {
                        imageDropDown.rotationEffect(.degrees(90))
                    } else {
                        imageDropDown.rotationEffect(.degrees(0))
                    }
                }
                .onTapGesture {
                    showingSelectQRTypeView = true
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .frame(maxHeight: 44)
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                VStack(spacing: 12) {
                    InputNameView(title: "Name", placeholder: "", name: "ok")
                    switch type {
                    case .website:
                        InputNameView(title: "Website Link", placeholder: "", name: "https://www.pinterest.com/pin/672021575660808069/")
                    case .contact:
                        InputNameView(title: "Contact Name", placeholder: "Enter Conntact Name", name: "")
                        InputPhoneNumberView(type: type)
                    case .text:
                        InputNameView(title: "Text", placeholder: "Enter a text here", name: "")
                    case .email:
                        InputNameView(title: "Email to", placeholder: "example@gmail.com", name: "")
                        InputNameView(title: "Subject", placeholder: "Enter subject", name: "")
                        DescriptionView(title: "E-mail Description", placeHolder: "", desc: "AAAA")
                    case .whatsapp:
                        InputNameView(title: "Contact Name", placeholder: "Enter Conntact Name", name: "")
                        InputPhoneNumberView(type: type)
                    case .instagram:
                        InputNameView(title: "Instagram URL", placeholder: "", name: "")
                    case .facebook:
                        InputNameView(title: "Facebook URL", placeholder: "", name: "")
                    case .twitter:
                        InputNameView(title: "Twitter URL", placeholder: "", name: "")
                    case .spotify:
                        InputNameView(title: "Spotify URL", placeholder: "", name: "")
                    case .youtube:
                        InputNameView(title: "Youtube URL", placeholder: "", name: "")
                    case .wifi:
                        InputNameView(title: "SSID", placeholder: "Enter Wifi name", name: "")
                        InputNameView(title: "Password", placeholder: "Enter password", name: "")
                        SecurityModeView()
                    case .paypal:
                        InputNameView(title: "Paypal URL", placeholder: "Enter link here", name: "")
                        DescriptionView(title: "Description", placeHolder: "Note for the payment")
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
        }
    }
    
    @ViewBuilder var imageDropDown: some View {
        Image(R.image.ic_left)
    }
}

struct SelectQRDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SelectQRDetailView(showingSelectQRTypeView: .constant(false), type: .website)
            .previewLayout(.sizeThatFits)
    }
}
