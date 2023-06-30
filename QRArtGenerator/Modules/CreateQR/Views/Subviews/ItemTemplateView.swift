//
//  ItemTemplateView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct ItemTemplateView: View {
    @Binding var template: TemplateModel
    @Binding var indexSelect: Int
    var index: Int = .zero
    var isSelect: Bool {
        index == indexSelect
    }
    
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
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        LinearGradient(colors: isSelect ? [R.color.color_6427C8.color, R.color.color_E79CB7.color] : [Color.clear],
                                                       startPoint: .bottomLeading,
                                                       endPoint: .topTrailing),
                                        lineWidth: 2
                                    )
                                    .frame(width: 101, height: 101)
                            }
                    default:
                        EmptyView()
                    }
                }
            }
            
            Text(template.name)
                .font(R.font.urbanistMedium.font(size: 12))
        }
        .frame(maxWidth: 103, maxHeight: 124)
    }
}

struct ItemTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        ItemTemplateView(template: .constant(TemplateModel(id: "", project: "", name: "", key: "", prompt: "", config: Config(negativePrompt: "", positivePrompt: ""), version: "", createdAt: "", updatedAt: "", v: 0)), indexSelect: .constant(0))
            .previewLayout(.sizeThatFits)
        
    }
}
