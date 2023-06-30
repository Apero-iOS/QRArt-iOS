//
//  HistoryView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

struct HistoryView: View {
    
    // MARK: - Variables
    @StateObject var viewModel: HistoryViewModel
    
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(R.image.history_logo_ic)
                
                Spacer()
                
                LottieView(lottieFile: R.file.crownJson.name)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        // TODO: Show iap
                    }
            }
            .frame(height: 48)
            
            Text(Rlocalizable.history())
                .font(R.font.urbanistBold.font(size: 28))
                .foregroundColor(R.color.color_1B232E.color)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.items.isEmpty {
                emptyView
            } else {
                listView
            }
        }
        .padding(.horizontal, 20)
        .hideNavigationBar()
        .onAppear {
            viewModel.setupData()
        }
    }
    
    // MARK: - ViewBuilder
    @ViewBuilder var emptyView: some View {
        Spacer()
            .frame(height: HEIGHT_SCREEN / 20)
        
        Image(R.image.history_empty_ic)
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
                // TODO: show create QR
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
        NavigationLink {
            SearchView()
        } label: {
            HStack(spacing: 12) {
                Image(R.image.search_ic)
                    .frame(width: 24)
                    .padding(.leading, 12)
                
                Text(Rlocalizable.search_qr_name())
                    .font(R.font.urbanistRegular.font(size: 14))
                    .foregroundColor(R.color.color_6A758B.color)
                
                Spacer()
            }
            .frame(height: 40)
            .background(.white)
            .overlay (
                RoundedRectangle(cornerRadius: 20)
                    .stroke(R.color.color_EAEAEA.color)
            )
        }
        .buttonStyle(.plain)
        
        HistoryCategoryListView(caterories: $viewModel.categories, selectedCate: $viewModel.selectedCate, onSelectCategory: { cate in
            viewModel.select(category: cate)
        })
        .padding(.horizontal, -20)
        
        HistoryListView(items: $viewModel.filteredItems, onDelete: { item in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                viewModel.delete(item: item)
            }
        })
    }
}

// MARK: - PreviewProvider
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(viewModel: HistoryViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}
