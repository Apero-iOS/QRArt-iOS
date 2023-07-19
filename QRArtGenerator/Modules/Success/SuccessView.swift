//
//  SuccessView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 03/07/2023.
//

import SwiftUI

struct SuccessView: View {
    @State private var isShowingBackground: Bool = false
    @State private var isShowingContent: Bool = false
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.45)
            VStack {
                VStack(spacing: 16) {
                    R.image.img_success.image
                    Text(Rlocalizable.saved_success())
                        .font(R.font.urbanistMedium.font(size: 16))
                        .foregroundColor(R.color.color_1C1818.color)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .multilineTextAlignment(.center)
                }
                Button {
                    Router.showHistory()
                } label: {
                    Text(Rlocalizable.back_to_home())
                        .font(R.font.urbanistSemiBold.font(size: 16))
                        .foregroundColor(R.color.color_0F1B2E.color)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(R.color.color_EAEAEA.color)
                .cornerRadius(45/2)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0))
            .frame(width: WIDTH_SCREEN - 68*2)
            .background(Color.white)
            .cornerRadius(12)
            .opacity(isShowingContent ? 1 : 0)
        }
        .opacity(isShowingBackground ? 1 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.1)) {
                isShowingBackground.toggle()
            }
            withAnimation(.easeOut(duration: 0.2).delay(0.15)) {
                isShowingContent.toggle()
            }
        }
        .ignoresSafeArea()
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
