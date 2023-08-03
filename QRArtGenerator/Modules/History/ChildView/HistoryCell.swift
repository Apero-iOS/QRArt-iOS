//
//  HistoryCell.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 29/06/2023.
//

import SwiftUI

struct HistoryCell: View {
    @State var item: QRItem
    @State private var showingDelete = false
    var canDelete: Bool
    var onDelete: VoidBlock?
    
    var body: some View {
        itemView(item)
    }
    
    private func itemView(_ item: QRItem) -> some View {
        VStack(alignment: .leading) {
            Image(uiImage: item.qrImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
            Text(item.createdDate.toString())
                .font(R.font.urbanistSemiBold.font(size: 12))
                .foregroundColor(R.color.color_1B232E.color)
                .frame(height: 16)
            Text(item.name)
                .font(R.font.urbanistSemiBold.font(size: 12))
                .foregroundColor(R.color.color_1B232E.color)
                .frame(height: 16)
    
            Spacer()
        }
    }
}

struct HistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCell(item: Constants.dummyQRs[0], canDelete: true)
    }
}
