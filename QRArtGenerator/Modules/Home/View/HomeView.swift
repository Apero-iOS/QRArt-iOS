//
//  HomeView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    let cellWidth = (WIDTH_SCREEN-55)/2.0
    var generateQRBlock: ((Template) -> Void)?
    
    var body: some View {
        let spacing: CGFloat = 15
        RefreshableScrollView {
            let count = Float(viewModel.templates.count)/2.0
            HStack(alignment: .top, spacing: spacing) {
                VStack {
                    ForEach(0..<Int(count.rounded(.up)), id: \.self) { i in
                        itemView(viewModel.templates[i*2])
                     
                    }
                }.frame(maxWidth: .infinity)
                
                VStack {
                    Spacer().frame(height: 40)
                    ForEach(0..<Int(count.rounded(.down)), id: \.self) { i in
                        itemView(viewModel.templates[i*2+1])
                    }
                }.frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            Spacer().frame(height: 120)
        }
        .onAppear {
            FirebaseAnalytics.logEvent(type: .home_view)
        }
        .toast(message: viewModel.msgError, isShowing: $viewModel.isShowToast, duration: 3)
        .refreshable {
            viewModel.fetchTemplate()
        }
    }
    
    private func itemView(_ template: Template) -> some View {
        VStack {
            AsyncImage(url: URL(string: template.key)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                case .empty:
                    EmptyView()
                        .skeleton(with: true, size: CGSize(width: cellWidth, height: cellWidth))
                        .shape(type: .rounded(.radius(8)))
                default:
                    R.image.img_error.image
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(height: 150)
                }
            }
            Spacer()
            Text(template.name)
                .font(R.font.urbanistSemiBold.font(size: 12))
                .foregroundColor(R.color.color_1B232E.color)
                .frame(height: 16)
            Spacer()
        }
        .frame(width: cellWidth, height: cellWidth*4/3)
        .background(Color.white)
        .border(radius: 30, color: .white, width: 8.0)
        .onTapGesture {
            generateQRBlock?(template)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
