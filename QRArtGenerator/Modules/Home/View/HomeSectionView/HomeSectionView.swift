//
//  HomeSectionView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 30/06/2023.
//

import SwiftUI
import SkeletonUI

struct HomeSectionView: View {
    
    var categoryName: String = ""
    var templates: [Template] = []
    var onViewMore: (() -> Void)? = nil
    
    @State var selection: Int? = nil
    @State var selectCtategory: String? = nil
    
    var body: some View {
        VStack {
            customHeader(with: categoryName, onViewMore: onViewMore)
            listContentCustom()
        }.frame(height: 154)
    }
    
    private func customHeader(with header: String, onViewMore: (() -> Void)? = nil) -> some View {
        HStack {
            Text(header)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
            Spacer()
            
            Button {
                selectCtategory = header
                FirebaseAnalytics.logEvent(type: .home_style_click,
                                           params: [.category: header])
            } label: {
                Text(Rlocalizable.view_more())
                    .font(R.font.beVietnamProMedium.font(size: 14))
                    .foregroundColor(R.color.color_653AE4.color)
            }
            .buttonStyle(.plain)
        }
        .background(NavigationLink("", destination:  DetailStylesView(templates: templates), tag: header, selection: $selectCtategory).opacity(0))
    }
    
    private func listContentCustom() -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(0..<templates.count, id: \.self) { index in
                    let item = templates[index]
                    let viewModel = CreateQRViewModel(source: .template, templateSelect: item, isPush: true)
                    NavigationLink(destination: CreateQRView(viewModel: viewModel), tag: index, selection: $selection) {
                        Button {
                            selection = index
                            FirebaseAnalytics.logEvent(type: .home_style_click,
                                                       params: [.style: item.name])
                        } label: {
                            itemView(item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private func itemView(_ template: Template) -> some View {
        VStack {
            AsyncImage(url: URL(string: template.key)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(12, antialiased: true)
                case .empty:
                    EmptyView()
                        .skeleton(with: true, size: CGSize(width: 103, height: 103))
                        .shape(type: .rounded(.radius(8)))
                default:
                    R.image.img_error.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(12, antialiased: true)
                }
            }
            Text(template.name)
                .font(R.font.beVietnamProSemiBold.font(size: 12))
                .foregroundColor(R.color.color_1B232E.color)
                .frame(height: 16)
        }.frame(width: 100, height: 121)
    }
}

struct HomeSessionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSectionView()
    }
}
