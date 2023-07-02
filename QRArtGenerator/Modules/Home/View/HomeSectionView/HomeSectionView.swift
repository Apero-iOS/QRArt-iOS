//
//  HomeSectionView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 30/06/2023.
//

import SwiftUI

struct HomeSectionView: View {
    
    var headerName: String
    var listItem: [Style] = []
    var onViewMore: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            customHeader(with: headerName, onViewMore: onViewMore)
                .padding(.horizontal, 20)
            listContentCustom()
        }.frame(height: 154)
        
    }

    private func customHeader(with header: String, onViewMore: (() -> Void)? = nil) -> some View {
        HStack {
            Text(header)
                .font(R.font.urbanistSemiBold.font(size: 16))
            Spacer()
            NavigationLink {
                DetailStylesView(styles: listItem)
            } label: {
                Text(Rlocalizable.view_more())
                    .font(R.font.urbanistMedium.font(size: 14))
                    .foregroundColor(R.color.color_653AE4.color)
            }
        }
    }
    
    private func listContentCustom() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(0..<listItem.count, id: \.self) { index in
                    let item = listItem[index]
                    itemView(item)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func itemView(_ item: Style) -> some View {
        VStack {
            AsyncImage(url: URL(string: item.key))
                .frame(width: 100, height: 100)
                .cornerRadius(12, antialiased: true)
            Text(item.name)
                .font(R.font.urbanistSemiBold.font(size: 12))
        }.frame(width: 100, height: 121)
    }
}

struct HomeSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSectionView(headerName: "Technology")
    }
}
