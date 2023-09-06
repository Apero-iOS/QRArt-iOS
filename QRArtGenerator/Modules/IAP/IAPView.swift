//
//  IAPView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 01/07/2023.
//

import SwiftUI
import Combine

enum SourceIAPView: String {
    case topBar = "top_bar"
    case download4K = "download_4k"
    case generateButton = "generate_button"
    case setting = "setting"
}

struct IAPView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var viewModel = IAPViewModel()
    @State var cancellable = Set<AnyCancellable>()
    var isAfterOnboarding: Bool = false
    var source: SourceIAPView = .setting
    var onClose: (() -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                Color(R.color.color_E7DCFF)
                    .frame(height: HEIGHT_SCREEN / 2)
                
                Spacer()
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    ZStack(alignment: .leading) {
                        Image(R.image.iap_banner_ic)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 283 / 375 * WIDTH_SCREEN)
                            .clipped()
                    }
                    
                    VStack(spacing: 16) {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text(Rlocalizable.go_further_with)
                                .font(R.font.beVietnamProSemiBold.font(size: 22))
                                .foregroundColor(R.color.color_1B232E.color)
                                .lineLimit(1)
                            
                            ZStack(alignment: .trailing) {
                                Text(Rlocalizable.pro_up)
                                    .font(R.font.beVietnamProBold.font(size: 20))
                                    .foregroundStyle(
                                        .linearGradient(colors: [R.color.color_FFAC4B.color, R.color.color_F6D210.color],
                                                        startPoint: .leading,
                                                        endPoint: .trailing)
                                    )
                                
                                Image(R.image.iap_pro_star_ic)
                                    .padding(.top, -20)
                                    .padding(.trailing, -8)
                            }
                            
                            Text(Rlocalizable.version_iap)
                                .font(R.font.beVietnamProSemiBold.font(size: 22))
                                .foregroundColor(R.color.color_1B232E.color)
                                .lineLimit(1)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.featureTitles, id: \.self) { title in
                                IAPFeatureView(title: title)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            ForEach(Array(viewModel.iapIds.enumerated()), id: \.offset) { index, type in
                                IAPCell(idType: type, index: index, selectedIndex: $viewModel.selectedIndex) {
                                    viewModel.onTap(index: index)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        Text(Rlocalizable.cancel_anytime)
                            .font(R.font.beVietnamProMedium.font(size: 14))
                            .foregroundColor(R.color.color_6A758B.color)
                        
                        Text(Rlocalizable.iap_description)
                            .font(R.font.beVietnamProRegular.font(size: 12))
                            .foregroundColor(R.color.color_6A758B.color)
                            .lineSpacing(3)
                        
                        termPrivacyView
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, (safeAreaInsets.bottom + 20))
                .background(.white)
            }
            .hideScrollIndicator()
            
            VStack {
                Image(R.image.iap_close_ic)
                    .frame(width: 24, height: 24)
                    .padding(.leading, 16)
                    .padding(.top, (safeAreaInsets.top + 8))
                    .onTapGesture {
                        onClose?()
                        dismiss()
                    }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            FirebaseAnalytics.logEvent(type: .sub_view, params: [.source: source.rawValue])
            viewModel.getInfoIAP()
            InappManager.share.didPaymentSuccess.sink { isSuccess in
                if isSuccess {
                    var package_time = ""
                    let subPurchase = viewModel.iapIds[viewModel.selectedIndex]
                    switch subPurchase {
                    case .month:
                        package_time = "month"
                    case .week:
                        package_time = "week"
                    case .lifetime:
                        package_time = "lifetime"
                    default:
                        break
                    }
                    
                    FirebaseAnalytics.logEvent(type: .sub_successfull, params: [.source: source.rawValue,
                                                                                .package_time: package_time])
                    if subPurchase.freeday == 3 {
                        FirebaseAnalytics.logEvent(type: .sub_successfull_3days_free_trial, params: [.source: source.rawValue,
                                                                                                     .package_time: package_time])
                    }
                    if isAfterOnboarding {
                        onClose?()
                    } else {
                        dismiss()
                        onClose?()
                    }
                }
                
            }.store(in: &cancellable)
        }
        .sheet(isPresented: $viewModel.showTerms) {
            NavigationView {
                WebView(urlString: Constants.termUrl)
                    .ignoresSafeArea()
                    .navigationTitle(Rlocalizable.terms_of_service())
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $viewModel.showPolicy) {
            NavigationView {
                WebView(urlString: Constants.policyUrl)
                    .ignoresSafeArea()
                    .navigationTitle(Rlocalizable.privacy_policy())
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    @ViewBuilder var termPrivacyView: some View {
        HStack(spacing: 16) {
            Text(Rlocalizable.terms_of_service)
                .font(R.font.beVietnamProBold.font(size: 12))
                .foregroundColor(R.color.color_6A758B.color)
                .onTapGesture {
                    viewModel.showTerms.toggle()
                }
            
            Rectangle()
                .frame(width: 1)
                .foregroundColor(R.color.color_6A758B.color)
            
            Text(Rlocalizable.privacy_policy)
                .font(R.font.beVietnamProBold.font(size: 12))
                .foregroundColor(R.color.color_6A758B.color)
                .onTapGesture {
                    viewModel.showPolicy.toggle()
                }
            
            Rectangle()
                .frame(width: 1)
                .foregroundColor(R.color.color_6A758B.color)
            
            Text(Rlocalizable.restore)
                .font(R.font.beVietnamProBold.font(size: 12))
                .foregroundColor(R.color.color_6A758B.color)
                .onTapGesture {
                    InappManager.share.restorePurchases()
                }
        }
    }
}

struct IAPView_Previews: PreviewProvider {
    static var previews: some View {
        IAPView()
    }
}
