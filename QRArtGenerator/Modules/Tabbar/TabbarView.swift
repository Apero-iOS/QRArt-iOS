//
//  TabbarView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI
import AVKit

struct TabbarView: View {
    
    @StateObject var viewModel = TabbarViewModel()
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                ZStack(alignment: .bottom) {
                    contentView
                        .padding(.bottom, viewModel.canShowBannerAd() ? 80 : 0)
                    
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
                                            viewModel.showCreateQR.toggle()
                                            FirebaseAnalytics.logEvent(type: .qr_creation_click)
                                        case .ai:
                                            checkCameraPermission()
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
                .background(Image(R.image.img_bg.name).resizable().frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea().scaledToFill())
                .ignoresSafeArea(edges: .bottom)
                .navigationBarTitleDisplayMode(.inline)
                .hideNavigationBar(isHidden: true)
            }
            
            if viewModel.showPopupGenQR {
                PopupCreateView {
                    viewModel.showPopupGenQR = false
                    viewModel.isShowChoosePhoto.toggle()
                } createButtonTap: {
                    viewModel.qrImage = nil
                    viewModel.qrString = nil
                    viewModel.showPopupGenQR = false
                    viewModel.showCreateQR.toggle()
                } outsideViewTap: {
                    viewModel.showPopupGenQR = false
                }
            }
            
            if viewModel.showTooltip, !UserDefaults.standard.tooltipsDone {
                TooltipsView(type: .home) {
                    viewModel.showPopupGenQR = false
                    viewModel.showCreateQR = true
                    viewModel.showTooltip = false
                }
            }

        }
        .fullScreenCover(isPresented: $viewModel.showScan) {
            ScannerView()
        }
        .fullScreenCover(isPresented: $viewModel.isShowChoosePhoto, content: {
            ChoosePhotoView { qrString, soruceImage in
                viewModel.qrImage = soruceImage
                viewModel.qrString = qrString
                viewModel.showCreateQR.toggle()
            }.ignoresSafeArea()
        })
        .fullScreenCover(isPresented: $viewModel.showCreateQR) {
            let vm = CreateQRViewModel(source: .create, templateSelect: viewModel.templateSelect, qrImage: viewModel.qrImage, baseUrl: viewModel.qrString)
            CreateQRView(viewModel: vm)
        }

        .fullScreenCover(isPresented: $viewModel.showIAP) {
            IAPView(source: .topBar)
        }
        .fullScreenCover(isPresented: $viewModel.showPopupAccessCamera) {
            AccessPhotoPopup(onTapAction: {
                FirebaseAnalytics.logEvent(type: .allow_access_click)
            }, onTapCancel: {
                FirebaseAnalytics.logEvent(type: .not_allow_click)
            })
            .background(TransparentBackground())
        }
        .onChange(of: viewModel.countSelectTab, perform: { newValue in
            if viewModel.isShowAds {
                viewModel.showAdsInter()
            }
        })
        .onAppear {
            viewModel.createIdAds()
            viewModel.cancellable.removeAll()
            InappManager.share.didPaymentSuccess.sink { isSuccess in
                if isSuccess {
                    viewModel.isVip = UserDefaults.standard.isUserVip
                }
                
            }.store(in: &viewModel.cancellable)
        }
    }
        
    @ViewBuilder var contentView: some View {
        TabView(selection: $viewModel.selectedTab) {
            HomeView(generateQRBlock: { template in
                if !UserDefaults.standard.tooltipsDone {
                    viewModel.showTooltip = true
                }
                viewModel.templateSelect = template
                viewModel.showPopupGenQR = true
            }, showIAP: {
                viewModel.showIAP.toggle()
            }).tag(TabbarEnum.home)
                .contentShape(Rectangle())
                .simultaneousGesture(DragGesture())
                
            HistoryView(createQRBlock: {
                setSelectedTab(tab: .home)
            }).tag(TabbarEnum.history)
                .contentShape(Rectangle())
                .simultaneousGesture(DragGesture())
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.selectedTab, perform: { newValue in
            viewModel.changeCountSelect()
            viewModel.logEventTracking(type: newValue)
        })
    }
    
    public func setSelectedTab(tab: TabbarEnum) {
        viewModel.selectedTab = tab
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized:
                    viewModel.showScan.toggle()
                case .notDetermined:
                    FirebaseAnalytics.logEvent(type: .permission_camera_view)
                    if await AVCaptureDevice.requestAccess(for: .video) {
                        /// permission granted
                        viewModel.showScan.toggle()
                        FirebaseAnalytics.logEvent(type: .permission_camera_allow_click)
                    } else {
                        /// permission Denied
                        viewModel.showPopupAccessCamera = true
                        FirebaseAnalytics.logEvent(type: .permission_camera_not_allow_click)
                    }
                case .denied, .restricted:
                    viewModel.showPopupAccessCamera = true
                    FirebaseAnalytics.logEvent(type: .permission_view)
                default: break
            }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
