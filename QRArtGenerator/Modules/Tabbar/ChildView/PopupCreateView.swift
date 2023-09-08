//
//  PopupCreateView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 12/08/2023.
//

import SwiftUI
import MobileAds

struct PopupCreateView: View {
    var uploadButtonTap: VoidBlock?
    var createButtonTap: VoidBlock?
    var outsideViewTap: VoidBlock?
    @State private var opacity: Double = 0
    @State private var showBottomView: Bool = false
    
    var isShowAdsInter: Bool {
        return RemoteConfigService.shared.bool(forKey: .inter_home) && !UserDefaults.standard.isUserVip
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .opacity(0.5)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showBottomView = false
                    }
                    withAnimation(.easeOut(duration: 0.2).delay(0.1)) {
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        outsideViewTap?()
                    }
                }
            
            if showBottomView {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            FirebaseAnalytics.logEvent(type: .home_upload_qr_click)
                            showAdsInter {
                                uploadButtonTap?()
                            }
                        } label: {
                            VStack {
                                Image(R.image.ic_upload_your_qr.name)
                                Text(Rlocalizable.upload_your_qr)
                                    .padding(.top, 12)
                                    .font(R.font.beVietnamProMedium.font(size: 14))
                                    .foregroundColor(R.color.color_1B232E.color)
                            }
                        }
                        Spacer()
                        Button {
                            FirebaseAnalytics.logEvent(type: .home_create_new_qr_click)
                            showAdsInter {
                                createButtonTap?()
                            }
                        } label: {
                            VStack {
                                Image(R.image.ic_create_new_qr.name)
                                Text(Rlocalizable.create_new_qr)
                                    .padding(.top, 12)
                                    .font(R.font.beVietnamProMedium.font(size: 14))
                                    .foregroundColor(R.color.color_1B232E.color)
                            }
                        }
                        Spacer()
                    }
                }
                .frame(height: 137)
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea()
        .opacity(opacity)
        .onAppear {
            FirebaseAnalytics.logEvent(type: .home_dialog_view)
            createIdAds()
            withAnimation(.easeOut(duration: 0.2)) {
                opacity = 1
            }
            withAnimation(.easeOut(duration: 0.2).delay(0.1)) {
                showBottomView = true
            }
        }
    }
    
    private func createIdAds() {
        if isShowAdsInter {
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .inter_home)
        }
    }
    
    private func showAdsInter(completion: VoidBlock?) {
        if isShowAdsInter {
            AdMobManager.shared.showIntertitial(unitId: .inter_home, blockDidDismiss: completion)
        } else {
            completion?()
        }
    }
}

struct PopupCreateView_Previews: PreviewProvider {
    static var previews: some View {
        PopupCreateView()
    }
}
