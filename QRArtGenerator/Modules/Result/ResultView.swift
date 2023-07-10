//
//  ResultView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

enum ResultViewSource {
    case history
    case create
}

struct ResultView: View {
    @StateObject var viewModel: ResultViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                naviView
                viewModel.image
                    .resizable()
                    .cornerRadius(24)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                    .frame(width: WIDTH_SCREEN, height: WIDTH_SCREEN, alignment: .center)
                    
                VStack {
                    if viewModel.isCreate {
                        HStack(spacing: 8) {
                            downloadButton
                            download4kButton
                        }
                        HStack {
                            regenerateButton
                            shareButton
                        }
                    } else {
                        HStack {
                            shareButton
                            downloadButton
                        }
                        download4kButton
                    }
                }
                Spacer()
                if viewModel.isShowAdsInter {
                    AdNativeView(adUnitID: .native_result, type: .medium)
                        .frame(height: 171)
                        .padding(.horizontal, 20)
                }
            }
            if viewModel.isShowSuccessView {
                SuccessView()
            }
        }
        .hideNavigationBar(isHidden: true)
        .sheet(isPresented: $viewModel.sheet, content: {
            ShareSheet(items: [viewModel.item.qrImage])
        })
        .fullScreenCover(isPresented: $viewModel.isShowLoadingView) {
            LoadingView()
        }
        .fullScreenCover(isPresented: $viewModel.showIAP) {
            IAPView()
        }
        .toast(message: viewModel.toastMessage, isShowing: $viewModel.isShowToast, position: .bottom)
        
    }
    
    @ViewBuilder var naviView: some View {
        NavibarView(title: viewModel.isCreate ? Rlocalizable.create_qr_title() : viewModel.item.name, isImageTitle: viewModel.isCreate ? true : false, isRightButton: false, titleRightButton: viewModel.isCreate ? Rlocalizable.save() : "") {
            viewModel.save()
        }
    }
    
    @ViewBuilder var shareButton: some View {
        ResultButtonView(typeButton: .share) {
            viewModel.share()
        }
    }
    
    @ViewBuilder var regenerateButton: some View {
        ResultButtonView(typeButton: .regenerate) {
            viewModel.showAdsInter()
        }
    }
    
    @ViewBuilder var downloadButton: some View {
        ResultButtonView(typeButton: .download, onTap: {
            viewModel.download()
        })
    }
    
    @ViewBuilder var download4kButton: some View {
        ResultButtonView(typeButton: .download4k, isCreate: viewModel.isCreate, onTap: {
            if !UserDefaults.standard.isUserVip {
                viewModel.showIAP.toggle()
            } else {
                viewModel.download4k()
            }
        })
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(viewModel: ResultViewModel(item: QRDetailItem(), image: Image(""), source: .create))
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
