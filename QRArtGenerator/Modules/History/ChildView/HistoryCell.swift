//
//  HistoryCell.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 29/06/2023.
//

import SwiftUI

struct HistoryCell: View {
    @State var item: QRDetailItem
    @State private var showingDelete = false
    var canDelete: Bool
    var onDelete: VoidBlock?
    
    var body: some View {
        itemView(item)
    }
    
    private func itemView(_ item: QRDetailItem) -> some View {
        VStack(alignment: .leading) {
            Image(uiImage: item.qrImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(12)
            
            HStack(spacing: 4) {
                Text(item.createdDate.toString(format: "HH:mm"))
                    .font(R.font.beVietnamProRegular.font(size: 12))
                    .foregroundColor(R.color.color_6A758B.color)
                    .frame(height: 16)
                
                Circle()
                    .frame(width: 2, height: 2)
                    .foregroundColor(R.color.color_6A758B.color)
                
                Text(item.createdDate.toString(format: "MMMM dd yyyy"))
                    .font(R.font.beVietnamProRegular.font(size: 12))
                    .foregroundColor(R.color.color_6A758B.color)
                    .frame(height: 16)
            }
            
            if item.createType == .custom {
                HStack {
                    item.type.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 16, height: 16)
                    
                    Text(item.type.title)
                        .font(R.font.beVietnamProRegular.font(size: 12))
                        .foregroundColor(R.color.color_6A758B.color)
                }
            }
    
            Spacer()
        }
    }
}

struct HistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCell(item: Constants.dummyQRs[0], canDelete: true)
    }
}
