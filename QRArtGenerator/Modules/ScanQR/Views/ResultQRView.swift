//
//  ResultQRView.swift
//  QRArtGenerator
//
//  Created by khac tao on 29/06/2023.
//

import SwiftUI

struct ResultQRView: View {
    
    @Binding var result: ResultQR
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            HStack {
                Image(R.image.ic_link)
                HStack {
                    Text(result.content)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .lineLimit(2)
                }
                .background(R.color.color_262930.color)
                .cornerRadius(12)
                Button {
                    // copy
                } label: {
                    Image(R.image.ic_copy)
                }
                Button {
                    // share
                } label: {
                    Image(R.image.ic_share)
                }
            }.frame(height: 44)
            
            HStack {
                ForEach(result.type.actions, id: \.self) { action in
                    Button {
                        
                    } label: {
                        Text(action.title)
                            .foregroundColor(.white)
                    }
                    .frame(height: 42)
                    .frame(maxWidth: .infinity)
                    .background(R.color.color_653AE4.color)
                    .cornerRadius(21)
                }
            }
        }
        .padding()
        .background(R.color.color_191A1F.color)
        
    }
}

struct ResultQRView_Previews: PreviewProvider {
    @State static var qrResult = ResultQR(type: .phone, content: "Apero")
    static var previews: some View {
        ResultQRView(result: $qrResult)
    }
}
