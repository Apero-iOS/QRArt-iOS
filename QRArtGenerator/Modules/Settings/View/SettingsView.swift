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
                    ZStack {
                        Image(R.image.img_banner_background)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .cornerRadius(12)
                        HStack {
                            Image(R.image.img_setting_banner)
                                .frame(width: 180, height: 150)
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
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 153)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    listItemView
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .listStyle(.grouped)
        .fullScreenCover(isPresented: $viewModel.isShowIAP) {
            IAPView()
        }
    }
    
    @ViewBuilder private var listItemView: some View {
        ForEach(viewModel.settings, id: \.self) { item in
            if item == .rate_app {
                Button {
                    Router.requestReview()
                } label: {
                    SettingRowView(item: item)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                }
            } else if item == .share_app {
                Button {
                    Router.actionSheet()
                } label: {
                    SettingRowView(item: item)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                }
            } else if item == .version {
                SettingRowView(item: item)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
            } else {
                NavigationLink {
                    switch item {
                        case .language:
                            let viewModel = LanguageViewModel(sourceOpen: .setting)
                            LanguageView(viewModel: viewModel)
                        case .privacy_policy:
                            WebView(urlString: Constants.policyUrl)
                                .ignoresSafeArea()
                                .navigationBarTitle(Rlocalizable.privacy_policy(), displayMode: .inline)
                        case .terms_of_service:
                            WebView(urlString: Constants.termUrl)
                                .ignoresSafeArea()
                                .navigationBarTitle(Rlocalizable.terms_of_service(), displayMode: .inline)
                        default:
                            Text(item.name)
                    }
                } label: {
                    SettingRowView(item: item)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                }
                
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
