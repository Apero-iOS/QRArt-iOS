//
//  BasicItemTemplateView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

struct BasicItemTemplateView: View {
    @Binding var indexSelect: Int?
    var index: Int = .zero
    var isSelect: Bool {
        index == indexSelect
    }
    
    var body: some View {
        VStack {
            Image(R.image.qr_basic).resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 103, height: 103)
                .cornerRadius(8)
                .clipped()
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(colors: isSelect ? [R.color.color_6427C8.color, R.color.color_E79CB7.color] : [Color.clear],
                                               startPoint: .bottomLeading,
                                               endPoint: .topTrailing),
                                lineWidth: 2
                            )
                            .frame(width: 101, height: 101)
                            .background(isSelect ? R.color.color_653AE4.color.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                            .clipped()
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(colors: isSelect ? [R.color.color_6427C8.color, R.color.color_E79CB7.color] : [Color.clear],
                                               startPoint: .bottomLeading,
                                               endPoint: .topTrailing),
                                lineWidth: 2
                            )
                            .frame(width: 101, height: 101)
                    }
                }
            Text(Rlocalizable.basic())
                .font(R.font.beVietnamProMedium.font(size: 12))
        }
        .frame(maxWidth: 103, maxHeight: 124)
    }
}

struct BasicItemTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        BasicItemTemplateView(indexSelect: .constant(0))
    }
}
