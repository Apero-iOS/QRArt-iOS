//
//  SelectQRTypeView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct SelectQRTypeView: View {
    @Binding var selectedType: QRType
    @Binding var showingSelectQRTypeView: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                Spacer()
                Text(Rlocalizable.select_qr_type)
                    .font(R.font.urbanistSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                    .frame(maxWidth: WIDTH_SCREEN, maxHeight: 29, alignment: .center)
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        showingSelectQRTypeView = false
                    } label: {
                        Text(Rlocalizable.done)
                            .font(R.font.urbanistMedium.font(size: 14))
                            .foregroundColor(R.color.color_007AFF.color)
                    }
                }
                .padding(.trailing, 16)
            }
            .frame(maxHeight: 29)
            List {
                ForEach(QRGroupType.allCases, id:  \.self) { section in
                    Section(header: Text(section.title)
                        .font(R.font.urbanistSemiBold.font(size: 16))
                        .foregroundColor(R.color.color_1B232E.color)
                        .padding(EdgeInsets())) {
                        ForEach(section.items, id: \.self) { item in
                            QRTypeView(type: item, selectedType: $selectedType)
                                .listRowInsets(EdgeInsets())
                        }
    
                    }
                }
            }
            .listStyle(.insetGrouped)
            .clearBackgroundColorList()
        }
        .background(R.color.color_F7F7F7.color)
    }
}

struct SelectQRTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectQRTypeView(selectedType: .constant(.facebook), showingSelectQRTypeView: .constant(false))
    }
}
