//
//  TabbarView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI

struct TabbarView: View {
    
    @StateObject var viewModel = TabbarViewModel()
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack(alignment: .bottom) {
                    contentView
                        .padding(.bottom, geo.safeAreaInsets.bottom)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        ZStack(alignment: .bottom) {
                            TabBarShape()
                                .fill(Color.white)
                                .frame(height: 64)
                                .shadow(color: R.color.color_D3D3D3_30.color, radius: 20, x: 0, y: -4)
                            
                            HStack(alignment: .bottom, spacing: 0) {
                                ForEach(viewModel.tabs, id: \.self) { tab in
                                    TabItem(width: WIDTH_SCREEN / CGFloat(viewModel.tabs.count), tab: tab, selectedTab: $viewModel.selectedTab) { _ in
                                        viewModel.currentTab = tab
                                        viewModel.changeCountSelect()
                                    }
                                }
                            }
                            .frame(width: WIDTH_SCREEN, height: 101, alignment: .bottom)
                        }
                        
                        Color.white
                            .frame(width: WIDTH_SCREEN, height: geo.safeAreaInsets.bottom)
                    }
                    
                }
                .ignoresSafeArea(edges: .bottom)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal, content: {
                        HStack {
                            Image(R.image.history_logo_ic)
                                .padding(.leading, 4)
                            
                            Spacer()
                            if !UserDefaults.standard.isUserVip {
                                LottieView(lottieFile: R.file.crownJson.name)
                                    .frame(width: 24, height: 24)
                                    .onTapGesture {
                                        viewModel.showIAP.toggle()
                                    }
                            }
                        }
                        .frame(width: WIDTH_SCREEN - 32, height: 48)
                    })
                }
                .hideNavigationBar(isHidden: viewModel.selectedTab == .settings)
            }
            .fullScreenCover(isPresented: $viewModel.showScan) {
                ScannerView()
            }
            .fullScreenCover(isPresented: $viewModel.showCreateQR) {
                let vm = CreateQRViewModel(source: .create, indexSelect: nil, list: nil)
                CreateQRView(viewModel: vm)
            }
            .fullScreenCover(isPresented: $viewModel.showIAP) {
                IAPView()
            }
        }
        .onChange(of: viewModel.countSelectTab, perform: { newValue in
            if viewModel.isShowAds {
                viewModel.showAdsInter()
            } else if viewModel.currentTab == .scan {
                viewModel.showScan.toggle()
            } else if viewModel.currentTab == .ai {
                viewModel.showCreateQR.toggle()
            }
        })
        .onAppear {
            viewModel.createIdAds()
        }
    }
    
    @ViewBuilder var contentView: some View {
        TabView(selection: $viewModel.selectedTab) {
            HistoryView().tag(TabbarEnum.history)
            
            HomeView().tag(TabbarEnum.home)
            
            SettingsView().tag(TabbarEnum.settings)
            
        }
        .onChange(of: viewModel.selectedTab, perform: { newValue in
            viewModel.currentTab = newValue
            viewModel.changeCountSelect()
        })
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
