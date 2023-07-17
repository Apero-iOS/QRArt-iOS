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
            VStack(spacing: 0) {
                naviView
                viewModel.image
                    .resizable()
                    .cornerRadius(24)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                    .frame(width: WIDTH_SCREEN, height: WIDTH_SCREEN, alignment: .center)
                    
                VStack {
                    if viewModel.isCreate {
                        HStack(spacing: 8) {
                            regenerateButton
                            saveAndShareButton
                        }
                        HStack {
                            download4kButton
                        }
                    } else {
                        shareButton
                        download4kButton
                    }
                }
                Spacer()
                if viewModel.isShowAdsInter, ReachabilityManager.isNetworkConnected() {
                    AdNativeView(adUnitID: .native_result, type: .medium)
                        .frame(height: 171)
                        .padding(.horizontal, 20)
                }
            }
            .hideNavigationBar(isHidden: true)
            .fullScreenCover(isPresented: $viewModel.sheet, content: {
                ShareSheet(items: [viewModel.item.qrImage])
            })
            .fullScreenCover(isPresented: $viewModel.showIAP) {
                IAPView()
            }
            .fullScreenCover(isPresented: $viewModel.isShowSuccessView, content: {
                SuccessView()
                    .background(TransparentBackground())
            })
            .toast(message: viewModel.toastMessage, isShowing: $viewModel.isShowToast, position: .bottom)
            if viewModel.isShowLoadingView {
                LoadingView()
            }
            
            if viewModel.showPopupAcessPhoto {
                AccessPhotoPopup {
                    viewModel.dissmissPopupAcessPhoto()
                } onTapCancel: {
                    viewModel.dissmissPopupAcessPhoto()
                }
                .padding(.all, 0)
            }
        }
    }
    
    @ViewBuilder var naviView: some View {
        NavibarView(title: viewModel.isCreate ? Rlocalizable.create_qr_title() : viewModel.item.name, isImageTitle: viewModel.isCreate ? true : false, isRightButton: false, titleRightButton: viewModel.isCreate ? Rlocalizable.done() : "") {
            viewModel.save()
        }
    }
    
    @ViewBuilder var shareButton: some View {
        ResultButtonView(typeButton: .share, isCreate: false) {
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
            viewModel.checkDownload()
        })
    }
    
    @ViewBuilder var download4kButton: some View {
        ResultButtonView(typeButton: .download4k, isCreate: false, onTap: {
            if !UserDefaults.standard.isUserVip {
                viewModel.showIAP.toggle()
            } else {
                viewModel.checkDownload4K()
            }
        })
    }
    
    @ViewBuilder var saveAndShareButton: some View {
        ResultButtonView(typeButton: .saveAndShare) {
            viewModel.saveAndShare()
        }
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

struct TransparentBackground: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
