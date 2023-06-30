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
    @Binding var showingSelectCountryView: Bool
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
                    InputNameView(title: Rlocalizable.name(),
                                  placeholder: "",
                                  name: "ok")
                    switch type {
                    case .website:
                        InputNameView(title: Rlocalizable.website_link(),
                                      placeholder: "",
                                      name: "https://www.pinterest.com/pin/672021575660808069/")
                    case .contact:
                        InputNameView(title: Rlocalizable.contact_name(),
                                      placeholder: Rlocalizable.enter_contact_name(),
                                      name: "")
                        InputPhoneNumberView(type: type,
                                             showingSelectCountryView: $showingSelectCountryView)
                    case .text:
                        InputNameView(title: Rlocalizable.text(),
                                      placeholder: Rlocalizable.enter_text_here(),
                                      name: "")
                    case .email:
                        InputNameView(title: Rlocalizable.email_to(),
                                      placeholder: "example@gmail.com",
                                      name: "")
                        InputNameView(title: Rlocalizable.subject(),
                                      placeholder: Rlocalizable.enter_subject(),
                                      name: "")
                        DescriptionView(title: Rlocalizable.email_desc(),
                                        placeHolder: "",
                                        desc: "AAAA")
                    case .whatsapp:
                        InputNameView(title: Rlocalizable.contact_name(),
                                      placeholder: Rlocalizable.enter_contact_name(),
                                      name: "")
                        InputPhoneNumberView(type: type,
                                             showingSelectCountryView: $showingSelectCountryView)
                    case .instagram:
                        InputNameView(title: Rlocalizable.instagram_url(),
                                      placeholder: "",
                                      name: "")
                    case .facebook:
                        InputNameView(title: Rlocalizable.facebook_url(),
                                      placeholder: "", name: "")
                    case .twitter:
                        InputNameView(title: Rlocalizable.twitter_url(),
                                      placeholder: "",
                                      name: "")
                    case .spotify:
                        InputNameView(title: Rlocalizable.spotify_url(),
                                      placeholder: "", name: "")
                    case .youtube:
                        InputNameView(title: Rlocalizable.youtube_url(),
                                      placeholder: "",
                                      name: "")
                    case .wifi:
                        InputNameView(title: Rlocalizable.ssid(),
                                      placeholder: Rlocalizable.enter_wifi_name(),
                                      name: "")
                        InputNameView(title: Rlocalizable.password(),
                                      placeholder: Rlocalizable.enter_password(),
                                      name: "")
                        SecurityModeView()
                    case .paypal:
                        InputNameView(title: Rlocalizable.paypal_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      name: "")
                        DescriptionView(title: Rlocalizable.desc(),
                                        placeHolder: Rlocalizable.note_payment())
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
        SelectQRDetailView(showingSelectQRTypeView: .constant(false), showingSelectCountryView: .constant(false), type: .website)
            .previewLayout(.sizeThatFits)
    }
}
