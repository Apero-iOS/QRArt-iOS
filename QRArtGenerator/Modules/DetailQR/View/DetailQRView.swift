//
//  DetailQRView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 10/08/2023.
//

import SwiftUI
import Combine
struct DetailQRView: View {
    @StateObject var viewModel: ResultViewModel
    @Environment(\.dismiss) private var dismiss
    @State var cancellable = Set<AnyCancellable>()
    var body: some View {
        contentView
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
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(Rlocalizable.time_created() + ": ")
                                    .font(R.font.beVietnamProSemiBold.font(size: 13))
                                    .foregroundColor(R.color.color_1B232E.color)
                                Text(viewModel.item.createdDate.toString())
                                    .font(R.font.beVietnamProRegular.font(size: 12))
                                    .foregroundColor(R.color.color_6A758B.color)
                            }
                            HStack {
                                Text(Rlocalizable.style_name() + ": ")
                                    .font(R.font.beVietnamProSemiBold.font(size: 13))
                                    .foregroundColor(R.color.color_1B232E.color)
                                Text(viewModel.item.templateQRName)
                                    .font(R.font.beVietnamProRegular.font(size: 12))
                                    .foregroundColor(R.color.color_6A758B.color)
                            }
                            if viewModel.item.createType == .normal {
                                HStack {
                                    Text(Rlocalizable.qr_code() + ": ")
                                        .font(R.font.beVietnamProSemiBold.font(size: 13))
                                        .foregroundColor(R.color.color_1B232E.color)
                                    Text(viewModel.item.baseUrl)
                                        .font(R.font.beVietnamProMediumItalic.font(size: 12))
                                        .foregroundColor(R.color.color_6A758B.color)
                                }
                            } else {
                                HStack {
                                    Text(Rlocalizable.qr_type() + ": ")
                                        .font(R.font.beVietnamProSemiBold.font(size: 13))
                                        .foregroundColor(R.color.color_1B232E.color)
                                    viewModel.item.type.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 16, height: 16)
                                    Text(viewModel.item.type.title)
                                        .font(R.font.beVietnamProRegular.font(size: 12))
                                        .foregroundColor(R.color.color_6A758B.color)
                                }
                                HStack {
                                    Text(Rlocalizable.link() + ": ")
                                        .font(R.font.beVietnamProSemiBold.font(size: 13))
                                        .foregroundColor(R.color.color_1B232E.color)
                                    Text(viewModel.item.urlString)
                                        .font(R.font.beVietnamProMediumItalic.font(size: 12))
                                        .foregroundColor(R.color.color_007AFF.color)
                                }
                            }
                        }.padding(.top, 12)
                        
                        download4kButton
                            .frame(height: 48)
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
                        .padding(.top, 16)
                        Spacer()
                    }
                    .padding(20)
                }
                if viewModel.isShowAd {
                    BannerView(adUnitID: .banner_result, fail: {
                        viewModel.isShowAd = false
                    }).frame(height: 50).frame(maxWidth: .infinity)
                }
            }
            .screenshotProtected(isProtected: true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Text(Rlocalizable.details)
                            .font(R.font.beVietnamProSemiBold.font(size: 18))
                            .lineLimit(1)
                            .padding(.trailing, 44)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.isShowDeleteAction.toggle()
                            }, label: {
                                Image(R.image.ic_trash)
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
            Rectangle()
                .fill(R.color.color_EAEAEA.color)
                .frame(width: WIDTH_SCREEN, height: 1)
            
        }
        .actionSheet(isPresented: $viewModel.isShowDeleteAction, content: {() -> ActionSheet in
            ActionSheet(title: Text(""), message: Text(Rlocalizable.message_delete_history),
                        buttons: [
                            .destructive(Text(Rlocalizable.delete), action: {
                                QRItemService.shared.deleteQR(viewModel.item)
                                dismiss()
                            }),
                            .cancel(Text(Rlocalizable.cancel), action: {
                                print("Cancel selected")
                            })
                        ])
        })
        .onAppear {
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
            Text("Regenerate")
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

struct DetailQRView_Previews: PreviewProvider {
    static var previews: some View {
        DetailQRView(viewModel: ResultViewModel(item: QRDetailItem(), image: Image("")))
    }
}
