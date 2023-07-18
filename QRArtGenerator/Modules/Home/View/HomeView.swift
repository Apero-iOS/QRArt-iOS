//
//  HomeView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                bannerView
                
                if viewModel.categories.isEmpty {
                    Spacer()
                    
                    ProgressView()
                        .tint(R.color.color_653AE4.color)
                        .frame(height: 150)
                } else {
                    ForEach(viewModel.categories) { category in
                        HomeSectionView(categoryName: category.name, templates: category.templates)
                    }
                }
 
                Spacer()
                Color(.clear)
                    .frame(height: 100)
            }
        }.toast(message: viewModel.msgError, isShowing: $viewModel.isShowToast, duration: 3)
            .refreshable {
                viewModel.fetchTemplate()
            }
    }
    
    @ViewBuilder var bannerView: some View {
        ZStack {
            Color(R.color.color_E5F3FF)
                .cornerRadius(11)
                .frame(height: 140, alignment: .bottom)
                .padding(.top)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(Rlocalizable.title_banner_home())
                            .font(R.font.urbanistSemiBold.font(size: 16))
                            .foregroundColor(R.color.color_1B232E.color)
                        Image(R.image.ic_shine_ai)
                            .frame(width: 28, height: 24)
                            .offset(y: -3)
                    }
                    Text(Rlocalizable.content_banner_home())
                        .font(R.font.urbanistRegular.font(size: 11))
                        .foregroundColor(R.color.color_1B232E.color)
                    Button {
                        viewModel.isShowGenerateQR.toggle()
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
                    .frame(width: 100, height: 24)
                    .background(Color(R.color.color_653AE4))
                    .clipShape(Capsule())
                    .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                Spacer()
                Image(R.image.frame_banner_home)
            }
        }
        .frame(height: 152)
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $viewModel.isShowGenerateQR) {
            let vm = CreateQRViewModel(source: .create, templateSelect: nil)
            CreateQRView(viewModel: vm)
        }.onTapGesture {
            viewModel.isShowGenerateQR.toggle()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
