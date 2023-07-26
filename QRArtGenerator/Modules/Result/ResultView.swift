//
//  ResultView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI
import ScreenshotPreventing

enum ResultViewSource {
    case history
    case create
}

struct ResultView: View {
    @StateObject var viewModel: ResultViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if !viewModel.isCreate {
            contentView
        } else {
            ZStack {
                NavigationView {
                    contentView
                }
                
                if viewModel.isShowSuccessView {
                    SuccessView()
                }
            }
        }
    }
    
    @ViewBuilder var contentView: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(R.color.color_EAEAEA.color)
                    .frame(width: WIDTH_SCREEN, height: 1)
                
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
            .screenshotProtected(isProtected: true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        if viewModel.isCreate {
                            Image(R.image.ic_close_screen)
                                .padding(.leading, 4)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text(viewModel.isCreate ? Rlocalizable.create_qr_title() : viewModel.item.name)
                                .font(R.font.urbanistSemiBold.font(size: 18))
                                .lineLimit(1)
                            
                            if viewModel.isCreate {
                                Image(R.image.ic_shine_ai)
                                    .frame(width: 28, height: 24)
                                    .offset(x: -3, y: -3)
                            }
                        }
                        
                        Spacer()
                        
                        Button(viewModel.isCreate ? Rlocalizable.done() : "") {
                            viewModel.isCreate ? viewModel.save() : ()
                        }
                        .font(R.font.urbanistSemiBold.font(size: 14))
                        .frame(width: 33)
                    }
                    .frame(height: 48)
                }
            }
            .fullScreenCover(isPresented: $viewModel.sheet, content: {
                ShareSheet(items: [viewModel.item.qrImage])
            })
            .fullScreenCover(isPresented: $viewModel.showIAP) {
                IAPView()
            }
            .fullScreenCover(isPresented: $viewModel.isShowLoadingView) {
                LoadingView()
            }
            .toast(message: viewModel.toastMessage, isShowing: $viewModel.isShowToast, duration: 3, position: .center)
            
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
        ResultButtonView(typeButton: .download4k, isCreate: viewModel.isCreate, onTap: {
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
