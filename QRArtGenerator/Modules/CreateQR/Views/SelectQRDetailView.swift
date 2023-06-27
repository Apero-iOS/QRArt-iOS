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
                .border(R.color.color_EAEAEA.color, width: 0.5)
                .cornerRadius(8)
                .onTapGesture {
                    showSelectQR = true
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
