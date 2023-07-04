//
//  ResultView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

struct ResultView: View {
    @Binding var image: Image
    var body: some View {
        VStack(spacing: 20) {
            naviView
            image
                .resizable()
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                .frame(width: WIDTH_SCREEN, height: WIDTH_SCREEN, alignment: .center)
            VStack {
                HStack(spacing: 8) {
                    ResultButtonView(typeButton: .download)
                    ResultButtonView(typeButton: .download4k)
                }
                HStack {
                    ResultButtonView(typeButton: .regenerate)
                    ResultButtonView(typeButton: .share)
                }
            }
            Spacer()
        }
        .hideNavigationBar(isHidden: true)
    }
    
    @ViewBuilder var naviView: some View {
        NavibarView(title: Rlocalizable.create_qr_title(), isImageTitle: true) {
            // TODO
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(image: .constant(Image("")))
    }
}
