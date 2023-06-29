//
//  HistoryListView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

struct HistoryListView: View {
    @Binding var items: [QRItem]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(items, id: \.id) { item in
                    HistoryCell(item: item)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 40)
        }
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
