//
//  QRTypeView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct QRTypeView: View {
    var type: QRType = .facebook
    @Binding var selectedType: QRType?
    
    var isSelected: Bool {
        selectedType == type
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(R.image.ic_checked)
                .opacity(isSelected ? 1 : 0)
            Text(type.title)
                .font(R.font.urbanistMedium.font(size: 16))
                .foregroundColor(R.color.color_1B232E.color)
            Spacer()
            type.image
                .frame(width: 28, height: 28, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .shadow(color: type.shadowColor,
                        radius: type.radiusShadow,
                        x: type.positionShadow.x,
                        y: type.positionShadow.y)
                
        }
        .frame(maxHeight: 52)
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .onTapGesture {
            if isSelected {
                selectedType = nil
            } else {
                selectedType = type
            }
        }
        .background(Color.white)
    }
}

struct QRTypeView_Previews: PreviewProvider {
    static var previews: some View {
        QRTypeView(type: .text, selectedType: .constant(.facebook))
            .previewLayout(.sizeThatFits)
    }
}
