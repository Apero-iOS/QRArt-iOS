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
        
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    viewModel.image
                        .resizable()
                        .cornerRadius(24)
                        .frame(width: WIDTH_SCREEN-40)
                        .aspectRatio(1.0, contentMode: .fill)
                    
                    if !viewModel.isCreate {
                        HStack {
                            Text("Time created:")
                            Text("June 25 2023")
                        }
                        HStack {
                            Text("Style Name:")
                            Text("June 25 2023")
                        }
                        HStack {
                            Text("QR Type:")
                            Text("June 25 2023")
                        }
                        HStack {
                            Text("Link:")
                            Text("June 25 2023")
                        }
                    }
                    download4kButton
                    Text("Share you QR")
                    ScrollView {
                        HStack(spacing: 10) {
                            VStack {
                                Image(R.image.ic_share.name).frame(height: 36).aspectRatio(1, contentMode: .fill)
                                Text("Twutter")
                                    .lineLimit(1)
                                
                            }
                            .onTapGesture {
                                QRHelper.share.shareImageViaTwitter(image: viewModel.item.qrImage)
                            }
                            VStack {
                                Image(R.image.ic_share.name).frame(height: 36).aspectRatio(1, contentMode: .fill)
                                Text("Facebook").lineLimit(1)
                            }.onTapGesture {
                                QRHelper.share.facebookShare(image: viewModel.item.qrImage)
                            }
                            VStack {
                                Image(R.image.ic_share.name).frame(height: 36).aspectRatio(1, contentMode: .fill)
                                Text("Instagram")
                                    .lineLimit(1)
                                  
                            }
                            .onTapGesture {
                                QRHelper.share.shareImageViaInstagram(image: viewModel.item.qrImage)
                            }
                            VStack {
                                Image(R.image.ic_share.name).frame(height: 36).aspectRatio(1, contentMode: .fill)
                                Text("Share").lineLimit(1)
                            }.onTapGesture {
                                viewModel.sheet.toggle()
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    if viewModel.isShowAdsInter, ReachabilityManager.isNetworkConnected() {
                        AdNativeView(adUnitID: .native_result, type: .medium)
                            .frame(height: 171)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(20)
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
                                    viewModel.save()
                                    dismiss()
                                }
                        }
                        Spacer()
                        HStack {
                            Text(viewModel.isCreate ? Rlocalizable.create_qr_title() : Rlocalizable.create_qr())
                                .font(R.font.urbanistSemiBold.font(size: 18))
                                .lineLimit(1)
                            
                            if viewModel.isCreate {
                                Image(R.image.ic_shine_ai)
                                    .frame(width: 28, height: 24)
                                    .offset(x: -3, y: -3)
                            }
                        }
                        
                        Spacer()
                        
                        if viewModel.isCreate {
                            regenerateButton.frame(width: 33)
                        } else {
                            Button(action: {
                                viewModel.isShowDeleteAction.toggle()
                            }, label: {
                                Text("Delete")
                                    .frame(width: 33)
                            })
                        }
                    }
                    .frame(height: 48)
                }
            }
            .sheet(isPresented:  $viewModel.sheet, content: {
                ShareSheet(items: [viewModel.item.qrImage])
            })
            .fullScreenCover(isPresented: $viewModel.showIAP) {
                IAPView(source: .download4K)
            }
            .fullScreenCover(isPresented: $viewModel.isShowLoadingView, onDismiss: {
                viewModel.isGenQRSuccess = false
            }) {
                LoadingView(isDismiss: $viewModel.isGenQRSuccess)
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
            Rectangle()
                .fill(R.color.color_EAEAEA.color)
                .frame(width: WIDTH_SCREEN, height: 1)
            
        }
        .actionSheet(isPresented: $viewModel.isShowDeleteAction, content: {() -> ActionSheet in
            ActionSheet(title: Text(""), message: Text("Would you like to delete  this QR?"),
                        buttons: [
                            .destructive(Text("Delete"), action: {
                                print("Ok selected")
                            }),
                            .cancel(Text("Cancel"), action: {
                                print("Cancel selected")
                            })
                        ])
        })
        .onAppear {
            FirebaseAnalytics.logEvent(type: .qr_creation_result_view, params: [.style: viewModel.item.templateQRName,
                                                                                .qr_type: viewModel.item.type.title,
                                                                                .guidance_number: "\(viewModel.item.guidance)",
                                                                                .step_number: "\(viewModel.item.steps)"])
        }
    }
    
    @ViewBuilder var shareButton: some View {
        ResultButtonView(typeButton: .share, isCreate: false) {
            viewModel.share()
        }
    }
    
    @ViewBuilder var regenerateButton: some View {
        Button {
            FirebaseAnalytics.logEvent(type: .qr_creation_regenerate_click)
            viewModel.showAdsInter()
        } label: {
            Text("Regenerate")
        }
    }
    
    @ViewBuilder var downloadButton: some View {
        ResultButtonView(typeButton: .download, onTap: {
            viewModel.checkDownload()
        })
    }
    
    @ViewBuilder var download4kButton: some View {
        ResultButtonView(typeButton: .download4k, isCreate: viewModel.isCreate, onTap: {
            FirebaseAnalytics.logEvent(type: .qr_creation_download_4k_click)
            if !UserDefaults.standard.isUserVip {
                viewModel.showIAP.toggle()
            } else {
                viewModel.checkDownload4K()
            }
        })
    }
    
    @ViewBuilder var saveAndShareButton: some View {
        ResultButtonView(typeButton: .saveAndShare) {
            FirebaseAnalytics.logEvent(type: .qr_creation_save_share_click)
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
