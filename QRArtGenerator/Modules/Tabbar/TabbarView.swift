//
//  TabbarView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI

struct TabbarView: View {
    
    @StateObject private var viewModel = TabbarViewModel()
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack(spacing: 0) {
                    Spacer()
                    
                    contentView
                    
                    Spacer()
                    
                    ZStack(alignment: .bottom) {
                        TabBarShape()
                            .fill(Color.white)
                            .frame(height: 64)
                            .shadow(color: R.color.color_D3D3D3_30.color, radius: 20, x: 0, y: -4)
                        
                        HStack(alignment: .bottom, spacing: 0) {
                            ForEach(viewModel.tabs, id: \.self) { tab in
                                TabItem(width: WIDTH_SCREEN / CGFloat(viewModel.tabs.count), tab: tab, selectedTab: $viewModel.selectedTab) {
                                    viewModel.showScan.toggle()
                                }
                            }
                        }
                        .frame(width: WIDTH_SCREEN, height: 101, alignment: .bottom)
                    }
                    
                    Color.white
                        .frame(width: WIDTH_SCREEN, height: geo.safeAreaInsets.bottom)
                }
                .ignoresSafeArea()
                .hideNavigationBar()
            }
        }.fullScreenCover(isPresented: $viewModel.showScan) {
            ScannerView()
        }
    }
    
    @ViewBuilder var contentView: some View {
        switch viewModel.selectedTab {
        case .history:
            HistoryView()
        default:
            Text(String(describing: viewModel.selectedTab))
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
