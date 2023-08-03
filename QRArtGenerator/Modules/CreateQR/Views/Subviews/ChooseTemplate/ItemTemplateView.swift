//
//  ItemTemplateView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI
import SkeletonUI

struct ItemTemplateView: View {
    @Binding var template: Template
    var index: Int = .zero
    
    var body: some View {
        VStack {
            if let url = URL(string: template.key) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 103, height: 103)
                            .cornerRadius(8)
                            .clipped()
                    case .empty:
                        EmptyView()
                            .skeleton(with: true, size: CGSize(width: 103, height: 103))
                            .shape(type: .rounded(.radius(8)))
                    default:
                        R.image.img_error.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 103, height: 103)
                            .cornerRadius(8)
                            .clipped()
                    }
                }
            }
            
            Text(template.name)
                .font(R.font.urbanistMedium.font(size: 12))
        }
        .frame(maxWidth: 103, maxHeight: 124)
    } 
}
