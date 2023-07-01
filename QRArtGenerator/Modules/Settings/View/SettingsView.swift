//
//  SettingsView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 28/06/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
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
                                Text(Rlocalizable.upgrade_to_qr())
                                    .font(R.font.urbanistBold.font(size: 14))
                                    .foregroundColor(R.color.color_1B232E.color)
                                Text(Rlocalizable.content_banner_setting())
                                    .font(R.font.urbanistRegular.font(size: 11))
                                    .foregroundColor(R.color.color_1B232E.color)
                                Button {
                                    //TODOs
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
                    
                    ForEach(viewModel.settings, id: \.self) { item in
                        NavigationLink {
                            switch item {
                            case .language:
                                LanguageView()
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
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .listStyle(.grouped)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
