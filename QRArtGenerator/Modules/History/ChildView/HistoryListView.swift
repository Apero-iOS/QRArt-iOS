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
    var showIAP: VoidBlock?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible())], spacing: 15) {
                ForEach(items, id: \.id) { item in
                    let vm = ResultViewModel(item: item as! QRDetailItem, image: Image(uiImage: item.qrImage))
                    NavigationLink {
                        DetailQRView(viewModel: vm) {
                            showIAP?()
                        }
                    } label: {
                        HistoryCell(item: item as! QRDetailItem, canDelete: isInHistory)
                    }
                }
            }
            Spacer().frame(height: 120)
        }
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
