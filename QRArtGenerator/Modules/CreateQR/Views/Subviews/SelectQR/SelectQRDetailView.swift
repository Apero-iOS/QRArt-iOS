//
//  SelectQRView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct SelectQRDetailView: View {
    @State var name: String = ""
    @Binding var showingSelectQRTypeView: Bool
    @Binding var showingSelectCountryView: Bool
    @Binding var validInput: Bool
    @Binding var input: QRDetailItem
    @Binding var countrySelect: Country
    
    var type: QRType
    
    var body: some View {
        VStack (spacing: 16) {
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
                                  placeholder: Rlocalizable.enter_qr_name(),
                                  name: $input.name,
                                  validInput: $validInput)
                    switch type {
                    case .website:
                        InputNameView(title: Rlocalizable.website_link(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      name: $input.urlString,
                                      validInput: $validInput)
                    case .contact:
                        InputNameView(title: Rlocalizable.contact_name(),
                                      placeholder: Rlocalizable.enter_contact_name(),
                                      name: $input.contactName,
                                      validInput: $validInput)
                        InputPhoneNumberView(type: type,
                                             phoneNumber: $input.phoneNumber,
                                             showingSelectCountryView: $showingSelectCountryView,
                                             validInput: $validInput,
                                             country: $countrySelect)
                    case .text:
                        InputNameView(title: Rlocalizable.text(),
                                      placeholder: Rlocalizable.enter_text_here(),
                                      name: $input.text,
                                      validInput: $validInput)
                    case .email:
                        InputEmailView(title: Rlocalizable.email_to(),
                                      placeholder: "Example@gmail.com",
                                      name: $input.emailAddress,
                                      validInput: $validInput)
                        InputNameView(title: Rlocalizable.subject(),
                                      placeholder: Rlocalizable.enter_subject(),
                                      name: $input.emailSubject,
                                      validInput: $validInput)
                        DescriptionView(title: Rlocalizable.email_desc(),
                                        placeHolder: Rlocalizable.enter_desc(),
                                        desc: $input.emailDescription,
                                        validInput: $validInput)
                    case .whatsapp:
                        InputNameView(title: Rlocalizable.contact_name(),
                                      placeholder: Rlocalizable.enter_contact_name(),
                                      name: $input.name,
                                      validInput: $validInput)
                        InputPhoneNumberView(type: type,
                                             phoneNumber: $input.phoneNumber,
                                             showingSelectCountryView: $showingSelectCountryView,
                                             validInput: $validInput,
                                             country: $countrySelect)
                    case .instagram:
                        InputNameView(title: Rlocalizable.instagram_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      name: $input.name,
                                      validInput: $validInput)
                    case .facebook:
                        InputNameView(title: Rlocalizable.facebook_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      name: $input.name,
                                      validInput: $validInput)
                    case .twitter:
                        InputNameView(title: Rlocalizable.twitter_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      name: $input.name,
                                      validInput: $validInput)
                    case .spotify:
                        InputNameView(title: Rlocalizable.spotify_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      name: $input.name,
                                      validInput: $validInput)
                    case .youtube:
                        InputNameView(title: Rlocalizable.youtube_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      name: $input.name,
                                      validInput: $validInput)
                    case .wifi:
                        InputNameView(title: Rlocalizable.ssid(),
                                      placeholder: Rlocalizable.enter_wifi_name(),
                                      name: $input.wfSsid, validInput: $validInput)
                        InputNameView(title: Rlocalizable.password(),
                                      placeholder: Rlocalizable.enter_password(),
                                      name: $input.wfPassword, validInput: $validInput)
                        SecurityModeView(wifiModeSelect: $input.indexWfSecurityMode)
                    case .paypal:
                        InputNameView(title: Rlocalizable.paypal_url(),
                                      placeholder: Rlocalizable.enter_link_here(),
                                      name: $input.urlString,
                                      validInput: $validInput)
                        AmountView(amount: $input.paypalAmount,
                                   validInput: $validInput)
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            R.color.color_F7F7F7.color
                .frame(height: 8)
        }
    }
    
    @ViewBuilder var imageDropDown: some View {
        Image(R.image.ic_left)
    }
}
