//
//  SelectQRView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI
import BottomSheet

struct SelectQRDetailView: View {
    @State var showSelectQR: Bool = false
    @State var name: String = ""
    var type: QRType = .text
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(Rlocalizable.select_qr_type)
                    .font(R.font.urbanistSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                HStack(alignment: .center, spacing: 12) {
                    Image(R.image.ic_website)
                    Text("Website")
                    Spacer()
                    Image(R.image.ic_dropdown)
                }
                .frame(maxHeight: 44)
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                .onTapGesture {
                    showSelectQR = true
                }
                VStack(spacing: 12) {
                    InputNameView(title: "Name", placeholder: "", name: "ok")
                    switch type {
                    case .website:
                        InputNameView(title: "Website Link", placeholder: "", name: "https://www.pinterest.com/pin/672021575660808069/")
                    case .contact:
                        InputNameView(title: "Contact Name", placeholder: "Enter Conntact Name", name: "")
                        InputPhoneNumberView()
                    case .text:
                        InputNameView(title: "Text", placeholder: "Enter a text here", name: "")
                    default:
                        VStack {
                            InputNameView()
                            SecurityModeView()
                        }
                    }
                    
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .bottomSheet(isPresented: $showSelectQR, height: 500) {
                SelectQRTypeView()
                    .padding(.leading, 0)
                    .padding(.trailing, 0)
            }
        }
        
    }
}

struct SelectQRDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SelectQRDetailView()
            .previewLayout(.sizeThatFits)
    }
}
