//
//  SuccessView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 03/07/2023.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack {
            
            VStack(spacing: 16) {
                R.image.img_success.image
                Text(Rlocalizable.saved_success())
                    .font(R.font.urbanistMedium.font(size: 16))
                    .foregroundColor(R.color.color_1C1818.color)
                
            }
            Button {
                
            } label: {
                Text(Rlocalizable.back_to_home())
                    .font(R.font.urbanistSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_0F1B2E.color)
            }
                .frame(height: 45)
                .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .background(R.color.color_EAEAEA.color)
            .cornerRadius(45/2)
        }
        .padding(EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0))
        .frame(width: WIDTH_SCREEN - 68*2)
        .background(Color.red)
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}