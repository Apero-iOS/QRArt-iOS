//
//  DetailStylesView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 01/07/2023.
//

import SwiftUI

struct DetailStylesView: View {
    
    @StateObject private var viewModel = DetailStylesViewModel()
    @State var styles: [Style]
    
    var body: some View {
        VStack {
            NavibarView(title: Rlocalizable.ai_art())
            ScrollView {
                LazyVGrid(columns: viewModel.getColumns()) {
                    ForEach(styles) { style in
                        itemView(style)                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .hideNavigationBar(isHidden: true)
    }
    
    private func itemView(_ item: Style) -> some View {
        VStack {
            let width = (WIDTH_SCREEN - 64)/3
            AsyncImage(url: URL(string: item.key))
                .frame(width: width, height: width)
                .cornerRadius(12, antialiased: true)
            Text(item.name)
                .font(R.font.urbanistSemiBold.font(size: 12))
        }
    }
}

struct DetailStylesView_Previews: PreviewProvider {
    static var previews: some View {
        DetailStylesView(styles: [])
    }
}
