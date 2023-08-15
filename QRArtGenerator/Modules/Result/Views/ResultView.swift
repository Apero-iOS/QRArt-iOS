//
//  ResultView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI
import ScreenshotPreventing
import Combine
import ExytePopupView

enum ResultViewSource {
    case history
    case create
}

struct ResultView: View {
    @StateObject var viewModel: ResultViewModel
    @Environment(\.dismiss) private var dismiss
    @State var cancellable = Set<AnyCancellable>()
    var onTapOderStyle: ((Template) -> Void)?
    
    var body: some View {
        ZStack {
            NavigationView {
                contentView
            }
            
            if viewModel.isShowSuccessView {
                SuccessView()
            }
        }
    }
    
    @ViewBuilder var contentView: some View {
        
        ZStack(alignment: .top) {
            VStack {
                 ScrollView {
                    VStack(alignment: .leading) {
                        
                        viewModel.image
                            .resizable()
                            .cornerRadius(24)
                            .frame(width: WIDTH_SCREEN-40)
                            .aspectRatio(1.0, contentMode: .fill)
                        
                        download4kButton
                        Text(Rlocalizable.share_your_qr)
                            .font(R.font.beVietnamProSemiBold.font(size: 16))
                            .padding(.top, 25)
                        HStack(spacing: 26) {
                            shareItem(name: "Instagram", icon: R.image.ic_share_instagram.image) {
                                QRHelper.share.shareImageViaInstagram(image: viewModel.item.qrImage)
                            }
                            
                            shareItem(name: "X", icon: R.image.ic_share_x.image) {
                                QRHelper.share.shareImageViaTwitter(image: viewModel.item.qrImage)
                            }
                            
                            shareItem(name: "Facebook", icon: R.image.ic_share_facebook.image) {
                                QRHelper.share.facebookShare(image: viewModel.item.qrImage)
                            }
                            
                            shareItem(name: "Share", icon: R.image.ic_share_system.image) {
                                viewModel.sheet.toggle()
                            }
                            
                        }
                        oderStyleView
                        
                    }
                    .padding(20)
          
                }
                
            }
            .screenshotProtected(isProtected: true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        HStack {
                            Text(Rlocalizable.result)
                                .font(R.font.beVietnamProSemiBold.font(size: 16))
                                .lineLimit(1)
                            
                            Image(R.image.ic_shine_ai)
                                .frame(width: 28)
                                .offset(x: -3, y: -3)
                        }
                        HStack {
                            Image(R.image.ic_close_screen)
                                .padding(.leading, 4)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.showPopupConfirm.toggle()
                                    }
                                }
                            Spacer()
                            
                            regenerateButton
                                .frame(width: 33, height: 26)
                                .padding(.trailing, 20)
                            
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
            .fullScreenCover(isPresented: $viewModel.isShowLoadingView) {
                LoadingView()
            }
            .fullScreenCover(isPresented: $viewModel.isShowIAP) {
                IAPView(source: .topBar)
            }
            .popup(isPresented: $viewModel.showPopupConfirm, view: {
                PopupConfirmSaveQR(onTapOk: {
                    viewModel.showPopupConfirm.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        viewModel.save()
                        dismiss()
                    }
                }, onTapNo: {
                    viewModel.showPopupConfirm.toggle()
                })
            }, customize: {
                $0
                    .type(.floater())
                    .position(.center)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            })
            
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
            viewModel.createIdInterCreateMore()
            FirebaseAnalytics.logEvent(type: .qr_creation_result_view, params: [.style: viewModel.item.templateQRName,
                                                                                .qr_type: viewModel.item.type.title,
                                                                                .guidance_number: "\(viewModel.item.guidance)",
                                                                                .step_number: "\(viewModel.item.steps)"])
            InappManager.share.didPaymentSuccess.sink { isSuccess in
                if isSuccess, viewModel.isShowAd {
                    viewModel.isShowAd = false
                }
            }.store(in: &cancellable)
        }
    }
    
    @ViewBuilder var shareButton: some View {
        ResultButtonView(typeButton: .share) {
            viewModel.share()
        }
    }
    
    @ViewBuilder var regenerateButton: some View {
        Button {
            FirebaseAnalytics.logEvent(type: .qr_creation_regenerate_click)
            viewModel.showAdsInter()
        } label: {
            HStack(spacing: 2) {
                Text(Rlocalizable.regenerate)
                    .font(R.font.beVietnamProSemiBold.font(size: 12))
                    .foregroundColor(R.color.color_653AE4.color)
                    .padding(.leading, 8)
                    .padding(.vertical, 4)
                Image(R.image.ic_giftbox.name)
                    .padding(.trailing, 8)
            }
            .border(radius: 20, color: R.color.color_653AE4.color, width: 1)
        }
    }
    
    @ViewBuilder var downloadButton: some View {
        ResultButtonView(typeButton: .download, onTap: {
            viewModel.checkDownload()
        })
    }
    
    @ViewBuilder var download4kButton: some View {
        ResultButtonView(typeButton: .download4k, onTap: {
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
    
    @ViewBuilder var oderStyleView: some View {
        Text(Rlocalizable.create_more)
            .font(R.font.beVietnamProSemiBold.font(size: 16))
            .padding(.top, 20)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<AppHelper.templates.count, id: \.self) { index in
                    templateView(item: AppHelper.templates[index])
                        .frame(width: 120, height: 120)
                        .cornerRadius(12)
                        .onTapGesture {
                            if AppHelper.templates[index].packageType != "basic" && !UserDefaults.standard.isUserVip {
                                viewModel.isShowIAP.toggle()
                            } else {
                                viewModel.showInterCreateMore {
                                    onTapOderStyle?(AppHelper.templates[index])
                                    dismiss()
                                }
                            }
                        }
                }
            }
        }
    }
    
    private func templateView(item: Template) -> some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .foregroundColor(.clear)
                .background(
                    AsyncImage(url: URL(string: item.key)) { phase in
                        switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .empty:
                                EmptyView()
                                    .skeleton(with: true, size: CGSize(width: 120, height: 120))
                                    .shape(type: .rounded(.radius(8)))
                            default:
                                R.image.img_error.image
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(height: 150)
                        }
                    })
            if item.packageType != "basic" && !UserDefaults.standard.isUserVip {
                Image(R.image.ic_style_sub.name)
                    .padding([.top, .trailing], 7)
            }
        }
    }
    
    private func shareItem(name: String, icon: Image, completion: @escaping VoidBlock) -> some View {
        VStack(spacing: 6) {
            icon
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 36, height: 36)
                .clipped()
            Text(name)
                .font(R.font.beVietnamProLight.font(size: 12))
                .foregroundColor(R.color.color_555555.color)
                .lineLimit(1)
            
        }.onTapGesture(perform: completion)
    }
    
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(viewModel: ResultViewModel(item: QRDetailItem(), image: Image("")))
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
