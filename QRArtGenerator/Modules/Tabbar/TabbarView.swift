//
//  TabbarView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI

struct TabbarView: View {
    
    @StateObject var viewModel = TabbarViewModel()
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                contentView
                    .padding(.bottom, viewModel.canShowBannerAd() ? safeAreaInsets.bottom + 80 : safeAreaInsets.bottom)
                
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
                                    switch tab {
                                        case .scan:
                                            viewModel.showScan.toggle()
                                        case .ai:
                                            viewModel.showCreateQR.toggle()
                                            FirebaseAnalytics.logEvent(type: .qr_creation_click)
                                        default:
                                            print("Không phải view present")
                                    }
                                }
                            }
                        }
                        .frame(width: WIDTH_SCREEN, height: 101, alignment: .bottom)
                    }
                    
                    /// View Ads
                    if viewModel.canShowBannerAd() {
                        BannerView(adUnitID: .banner_tab_bar, fail: {
                            viewModel.failAds = true
                        })
                        .frame(height: 50)
                        
                    }
                    
                    Color
                        .white
                        .frame(width: WIDTH_SCREEN, height: safeAreaInsets.bottom)
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
            let vm = CreateQRViewModel(source: .create, templateSelect: nil)
            CreateQRView(viewModel: vm)
        }
        .fullScreenCover(isPresented: $viewModel.showIAP) {
            IAPView(source: .topBar)
        }
        .onChange(of: viewModel.countSelectTab, perform: { newValue in
            if viewModel.isShowAds {
                viewModel.showAdsInter()
            }
        })
        .onAppear {
            viewModel.createIdAds()
            InappManager.share.didPaymentSuccess.sink { isSuccess in
                if isSuccess {
                    viewModel.isVip = UserDefaults.standard.isUserVip
                }
                
            }.store(in: &viewModel.cancellable)
        }
    }
    
    @ViewBuilder var contentView: some View {
        TabView(selection: $viewModel.selectedTab) {
            HomeView().tag(TabbarEnum.home)
                .contentShape(Rectangle())
                .simultaneousGesture(DragGesture())
            
            HistoryView().tag(TabbarEnum.history)
                .contentShape(Rectangle())
                .simultaneousGesture(DragGesture())
            
            SettingsView().tag(TabbarEnum.settings)
                .contentShape(Rectangle())
                .simultaneousGesture(DragGesture())
            
        }
        .tabViewStyle(.page)
        .onChange(of: viewModel.selectedTab, perform: { newValue in
            viewModel.changeCountSelect()
        })
    }
    
    public func setSelectedTab(tab: TabbarEnum) {
        viewModel.selectedTab = tab
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
