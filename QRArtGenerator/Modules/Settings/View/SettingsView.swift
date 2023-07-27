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
            Text(Rlocalizable.settings)
                .font(R.font.urbanistBold.font(size: 28))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            ScrollView {
                LazyVStack {
                    bannerSettingView
                    listItemView
                }
            }
            Spacer()
        }
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
        ZStack {
            Image(R.image.img_banner_background)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(12)
            HStack {
                Image(R.image.img_setting_banner)
                    .frame(width: 180, height: 150)
                if viewModel.isVip {
                    contentBannerVip
                } else {
                    contentBannerNormal
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 153)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder private var contentBannerVip: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .trailing) {
                Image(R.image.ic_pro)
                Text("You're On")
                    .font(R.font.urbanistBold.font(size: 24))
                    .foregroundColor(R.color.color_1B232E.color)
                Text("Premium!")
                    .font(R.font.urbanistBold.font(size: 24))
                    .foregroundColor(R.color.color_1B232E.color)
            }
            R.image.ic_shine.image
                .resizable()
                .frame(width: 18, height: 18)
                .scaledToFill()
                .padding(.bottom, 6.0)
        }
    }
    
    @ViewBuilder private var contentBannerNormal: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Text(Rlocalizable.upgrade_to_qr())
                    .font(R.font.urbanistBold.font(size: 14))
                    .foregroundColor(R.color.color_1B232E.color)
                Image(R.image.ic_pro)
            }
            Text(Rlocalizable.content_banner_setting())
                .font(R.font.urbanistRegular.font(size: 11))
                .foregroundColor(R.color.color_1B232E.color)
            if !UserDefaults.standard.isUserVip {
                Button {
                    viewModel.isShowIAP.toggle()
                } label: {
                    HStack {
                        Text(Rlocalizable.try_it_out())
                            .font(R.font.urbanistBold.font(size: 12))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Image(R.image.ic_shine)
                    }
                    .fixedSize()
                }
                .frame(width: 100, height: 32)
                .background(Color(R.color.color_653AE4))
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
