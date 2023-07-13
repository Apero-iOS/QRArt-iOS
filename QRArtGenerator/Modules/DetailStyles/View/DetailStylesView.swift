//
//  DetailStylesView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 01/07/2023.
//

import SwiftUI

struct DetailStylesView: View {
    
    @StateObject private var viewModel = DetailStylesViewModel()
    @State var template: TemplateModel? = nil
    
    var body: some View {
        VStack {
            NavibarView(title: Rlocalizable.ai_art())
            ScrollView {
                LazyVGrid(columns: viewModel.getColumns()) {
                    if let template = self.template {
                        ForEach(0..<template.styles.count, id: \.self) { index in
                            NavigationLink {
                                let viewModel = CreateQRViewModel(source: .template, idTemplateSelect: template.id)
                                CreateQRView(viewModel: viewModel)
                            } label: {
                                itemView(template.styles[index])
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .hideNavigationBar(isHidden: true)
    }
    
    private func itemView(_ item: Style) -> some View {
        VStack {
            let width = (WIDTH_SCREEN - 64)/3
            AsyncImage(url: URL(string: item.key))
                .frame(width: width, height: width)
                .cornerRadius(12, antialiased: true)
            Text(item.name)
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
