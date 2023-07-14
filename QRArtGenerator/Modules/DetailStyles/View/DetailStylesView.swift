//
//  DetailStylesView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 01/07/2023.
//

import SwiftUI

struct DetailStylesView: View {
    
    @StateObject private var viewModel = DetailStylesViewModel()
    @State var templates: [Template] = []
    
    var body: some View {
        VStack {
            NavibarView(title: templates.first?.category ?? "")
            ScrollView {
                LazyVGrid(columns: viewModel.getColumns()) {
                    ForEach(0..<templates.count, id: \.self) { index in
                        NavigationLink {
                            let viewModel = CreateQRViewModel(source: .template, templateSelect: templates[index])
                            CreateQRView(viewModel: viewModel)
                        } label: {
                            itemView(templates[index])
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            
            /// View Ads
            if viewModel.isShowAdsBanner {
                BannerView(adUnitID: .banner_tab_bar)
                    .frame(height: 50)
            }
        }
        .hideNavigationBar(isHidden: true)
    }
    
    private func itemView(_ template: Template) -> some View {
        VStack {
            let width = (WIDTH_SCREEN - 64)/3
            AsyncImage(url: URL(string: template.key)) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: width)
                            .cornerRadius(12, antialiased: true)
                    default:
                        R.image.img_error.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: width)
                            .cornerRadius(12, antialiased: true)
                }
            }
            Text(template.name)
                .font(R.font.urbanistSemiBold.font(size: 12))
                .foregroundColor(R.color.color_1B232E.color)
        }
    }
}

struct DetailStylesView_Previews: PreviewProvider {
    static var previews: some View {
        DetailStylesView()
    }
}
