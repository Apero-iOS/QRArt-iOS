//
//  HistoryView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

struct HistoryView: View {
    
    // MARK: - Variables
    @StateObject var viewModel = HistoryViewModel()
    var createQRBlock: VoidBlock?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Color.clear
                .frame(height: 0)
            if viewModel.items.isEmpty {
                emptyView
            } else {
                listView
            }
        }
        .onAppear {
            FirebaseAnalytics.logEvent(type: .history_view)
        }
        .padding(.horizontal, 20)
        .hideNavigationBar(isHidden: true)
    }
    
    // MARK: - ViewBuilder
    @ViewBuilder var emptyView: some View {
        Spacer()
            .frame(height: HEIGHT_SCREEN / 20)
        
        Image(R.image.history_empty_ic.name)
            .aspectRatio(contentMode: .fit)
        
        VStack(spacing: 24) {
            VStack(alignment: .center, spacing: 4) {
                Text(Rlocalizable.artify_your_qr_codes)
                    .font(R.font.urbanistBold.font(size: 18))
                    .foregroundColor(R.color.color_1B232E.color)
                
                Text(Rlocalizable.no_qrs_created_yet)
                    .font(R.font.urbanistRegular.font(size: 16))
                    .foregroundColor(R.color.color_6A758B.color)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                createQRBlock?()
                FirebaseAnalytics.logEvent(type: .history_qr_click)
            } label: {
                Text(Rlocalizable.create_qr())
                    .font(R.font.urbanistSemiBold.font(size: 14))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color.white)
            }
            .frame(width: 156, height: 34)
            .background(R.color.color_653AE4.color)
            .clipShape(Capsule())
        }
        .padding(.horizontal, 40)
        .opacity(1)
        Spacer()
    }
    
    @ViewBuilder var listView: some View {
        HistoryListView(items: $viewModel.filteredItems, isInHistory: true, onDelete: { item in
            if #available(iOS 16.0, *) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    viewModel.delete(item: item)
                }
            } else {
                viewModel.delete(item: item)
            }
        })
    }
}

// MARK: - PreviewProvider
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}
