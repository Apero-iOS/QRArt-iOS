//
//  ResultView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

struct ResultView: View {
    @StateObject var viewModel: ResultViewModel
    @Binding var image: Image
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                naviView
                image
                    .resizable()
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                    .frame(width: WIDTH_SCREEN, height: WIDTH_SCREEN, alignment: .center)
                VStack {
                    HStack(spacing: 8) {
                        ResultButtonView(typeButton: .download, onTap: {
                            viewModel.download()
                        })
                        ResultButtonView(typeButton: .download4k, onTap: {
                            viewModel.download4k()
                        })
                    }
                    HStack {
                        ResultButtonView(typeButton: .regenerate)
                        ResultButtonView(typeButton: .share)
                    }
                }
                Spacer()
            }
            if viewModel.isShowSuccessView {
                SuccessView()
            }
        }
        .hideNavigationBar(isHidden: true)
    }
    
    @ViewBuilder var naviView: some View {
        NavibarView(title: Rlocalizable.create_qr_title(), isImageTitle: true, titleRightButton: Rlocalizable.save()) {
            viewModel.save()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(viewModel: ResultViewModel(item: QRDetailItem()), image: .constant(Image("")))
    }
}
