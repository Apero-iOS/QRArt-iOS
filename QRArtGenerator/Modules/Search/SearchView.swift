//
//  SearchView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 30/06/2023.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(R.image.search_ic)
                        .frame(width: 24)
                        .padding(.leading, 12)
                    
                    TextField(Rlocalizable.search_qr_name(), text: .constant(""))
                        .font(R.font.urbanistRegular.font(size: 14))
                        .foregroundColor(R.color.color_1B232E.color)
                }
                .frame(height: 40)
                .overlay (
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(R.color.color_EAEAEA.color)
                )
                
                Button(Rlocalizable.cancel()) {
                    dismiss()
                }
                .font(R.font.urbanistMedium.font(size: 14))
            }
            .padding(.all, 16)
            
            R.color.color_EAEAEA.color
                .frame(width: WIDTH_SCREEN, height: 1)
            
            emptyView
            
            Spacer()
        }
        .hideNavigationBar()
    }
    
    @ViewBuilder var emptyView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 28) {
                Image(R.image.search_empty_ic)
                
                Text(Rlocalizable.no_qr_found())
                    .font(R.font.urbanistSemiBold.font(size: 17))
                    .foregroundColor(R.color.color_0F1B2E.color)
            }
            
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
