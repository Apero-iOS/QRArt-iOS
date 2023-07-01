//
//  HistoryListView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

struct HistoryListView: View {
    @Binding var items: [QRItem]
    var isInHistory: Bool
    var onDelete: ((QRItem) -> Void)?
    
    var body: some View {
        List {
            Section(content: {
                ForEach(items, id: \.id) { item in
                    HistoryCell(item: item, canDelete: isInHistory, onDelete: {
                        onDelete?(item)
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    .hideSeparatorLine()
                }
            }, footer: {
                Color.clear
                    .frame(height: isInHistory ? 70 : 20)
            }
            )
            .hideSeparatorLine()
        }
        .hideScrollIndicator()
        .listStyle(.plain)
        
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
