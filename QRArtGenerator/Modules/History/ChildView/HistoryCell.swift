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
        VStack {
            HStack(alignment: .top, spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    Image(uiImage: item.qrImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.name)
                            .font(R.font.urbanistSemiBold.font(size: 14))
                            .foregroundColor(R.color.color_1B232E.color)
                            .lineLimit(1)
                        
                        HStack(alignment: .center, spacing: 4) {
                            Text(item.createdDate.toString(format: "HH:mm"))
                                .font(R.font.urbanistRegular.font(size: 12))
                                .foregroundColor(R.color.color_6A758B.color)
                                .lineLimit(1)
                            
                            Circle()
                                .frame(width: 2, height: 2)
                                .background(R.color.color_6A758B.color)
                            
                            Text(item.createdDate.toString(format: "MMMM dd yyyy"))
                                .font(R.font.urbanistRegular.font(size: 12))
                                .foregroundColor(R.color.color_6A758B.color)
                                .lineLimit(1)
                        }
                        
                        HStack(alignment: .center, spacing: 4) {
                            item.type.image
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                            Text(item.type.title)
                                .font(R.font.urbanistRegular.font(size: 12))
                                .foregroundColor(R.color.color_6A758B.color)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 0))
                
                Spacer(minLength: 20)
                
                if canDelete {
                    Image(R.image.trash_ic)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            showingDelete = true
                        }
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 12))
                        .confirmationDialog(Rlocalizable.would_you_like_to_delete(), isPresented: $showingDelete, titleVisibility: .visible) {
                            Button(Rlocalizable.delete(), role: .destructive) {
                                onDelete?()
                            }
                        }
                }
            }
            .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
        }
    }
}

struct HistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCell(item: Constants.dummyQRs[0], canDelete: true)
    }
}
