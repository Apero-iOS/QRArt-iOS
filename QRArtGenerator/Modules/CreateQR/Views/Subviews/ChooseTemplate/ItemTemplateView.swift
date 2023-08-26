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
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 140, height: 140)
                    .background(
                        AsyncImage(url: url) { phase in
                            switch phase {
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(8)
                                        .clipped()
                                case .empty:
                                    EmptyView()
                                        .skeleton(with: true, size: CGSize(width: 120, height: 120))
                                        .shape(type: .rounded(.radius(8)))
                                default:
                                    R.image.img_error.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(8)
                                        .clipped()
                            }
                        }
                    )
                    .border(radius: 12, color: R.color.color_653AE4.color, width: 4)
                
            }
            
            Text(template.name)
                .font(R.font.beVietnamProRegular.font(size: 13))
        }
        .frame(maxWidth: 103, maxHeight: 124)
    } 
}
