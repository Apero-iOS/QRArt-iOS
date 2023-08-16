//
//  SettingsView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 28/06/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView {
                LazyVStack {
                    bannerSettingView
                    listItemView
                }
            }.clipped()
            Spacer()
        }
        .navigationTitle(Rlocalizable.settings())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .listStyle(.grouped)
        .fullScreenCover(isPresented: $viewModel.isShowIAP) {
            IAPView(source: .setting)
        }
       
        .onAppear {
            InappManager.share.didPaymentSuccess.sink { isSuccess in
                if isSuccess {
                    viewModel.isVip = UserDefaults.standard.isUserVip
                }
                
            }.store(in: &viewModel.cancellable)
        }
    }
    
    @ViewBuilder private var bannerSettingView: some View {
        ZStack(alignment: .leading) {
            Image(R.image.img_setting_banner)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(12)

                if viewModel.isVip {
                    contentBannerVip
                        .padding(.leading, 25)
                } else {
                    contentBannerNormal
                        .padding(.leading, 20)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: 153)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder private var contentBannerVip: some View {
        VStack(alignment: .leading) {
            Text(Rlocalizable.youre_on)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
                .foregroundColor(.white)
            Text(Rlocalizable.premium)
                .font(R.font.beVietnamProSemiBold.font(size: 22))
                .overlay {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.68, blue: 0.3), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.97, green: 0.82, blue: 0.06), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 1),
                        endPoint: UnitPoint(x: 1, y: 0)
                    ).mask {
                        Text(Rlocalizable.premium)
                            .font(R.font.beVietnamProSemiBold.font(size: 22))
                    }
                }
        }
    }
    
    @ViewBuilder private var contentBannerNormal: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Rlocalizable.title_setting_banner)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
                .foregroundColor(.white)
            Text(Rlocalizable.content_setting_banner)
                .font(R.font.beVietnamProRegular.font(size: 11))
                .foregroundColor(.white)
            if !UserDefaults.standard.isUserVip {
                Button {
                    viewModel.isShowIAP.toggle()
                } label: {
                    HStack {
                        Text(Rlocalizable.create_now)
                            .font(R.font.beVietnamProSemiBold.font(size: 12))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        Image(R.image.ic_shine)
                            .colorMultiply(.black)
                    }
                    .fixedSize()
                }
                .frame(width: 100, height: 28)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.68, blue: 0.3), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.97, green: 0.82, blue: 0.06), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 1),
                        endPoint: UnitPoint(x: 1, y: 0)
                    )
                )
                .cornerRadius(100)
            }
        }
    }
    
    @ViewBuilder private var listItemView: some View {
        ForEach(viewModel.settings, id: \.self) { item in
            switch item {
                case .language:
                    languageView(item)
                case .privacy_policy:
                    privacyPolicyView(item)
                case .terms_of_service:
                    termsOfServiceView(item)
                case .rate_app:
                    rateAppView(item)
                case .share_app:
                    shareAppView(item)
                case .version:
                    SettingRowView(item: item)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
            }
        }
    }
    
    private func shareAppView(_ type: SettingType) -> some View {
        Button {
            Router.actionSheet()
            FirebaseAnalytics.logEvent(type: .setting_share_app)
        } label: {
            SettingRowView(item: type)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
    }
    
    private func rateAppView(_ type: SettingType) -> some View {
        Button {
            Router.requestReview()
            FirebaseAnalytics.logEvent(type: .setting_rate_app)
        } label: {
            SettingRowView(item: type)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
    }
    
    private func languageView(_ type: SettingType) -> some View {
        NavigationLink(destination: LanguageView(viewModel: LanguageViewModel(sourceOpen: .setting)), tag: type, selection: $viewModel.activeScreen) {
            Button {
                viewModel.activeScreen = type
                FirebaseAnalytics.logEvent(type: .setting_language)
            } label: {
                SettingRowView(item: type)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
            }
        }
    }
    
    private func privacyPolicyView(_ type: SettingType) -> some View {
        NavigationLink(destination: WebView(urlString: Constants.termUrl)
            .ignoresSafeArea()
            .navigationBarTitle(Rlocalizable.privacy_policy(), displayMode: .inline),
                       tag: type,
                       selection: $viewModel.activeScreen) {
            Button {
                viewModel.activeScreen = type
                FirebaseAnalytics.logEvent(type: .setting_pricacy_policy)
            } label: {
                SettingRowView(item: type)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
            }
        }
    }
    
    private func termsOfServiceView(_ type: SettingType) -> some View {
        NavigationLink(destination: WebView(urlString: Constants.termUrl)
            .ignoresSafeArea()
            .navigationBarTitle(Rlocalizable.terms_of_service(), displayMode: .inline),
                       tag: type,
                       selection: $viewModel.activeScreen) {
            Button {
                viewModel.activeScreen = type
                FirebaseAnalytics.logEvent(type: .setting_term_of_service)
            } label: {
                SettingRowView(item: type)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
