//
//  AccessPhotoPopup.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 13/07/2023.
//

import SwiftUI

struct AccessPhotoPopup: View {
    
    var onTapAction: (() -> Void)? = nil
    var onTapCancel: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color(.black).opacity(0.45)
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    LottieView(lottieFile: R.file.cameraAccessJson.name)
                        .frame(width: 100, height: 100)
                    VStack(spacing: 4) {
                        Text(Rlocalizable.photos_access)
                            .font(R.font.urbanistSemiBold.font(size: 16))
                            .foregroundColor(R.color.color_1B232E.color)
                            .multilineTextAlignment(.center)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        
                        Text(Rlocalizable.photos_access_desc)
                            .font(R.font.urbanistRegular.font(size: 14))
                            .foregroundColor(R.color.color_1B232E.color)
                            .multilineTextAlignment(.center)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
                
                VStack(spacing: 8) {
                    Button {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: { _ in 
                            onTapAction?()
                        })

                    } label: {
                        Text(Rlocalizable.allow_access)
                            .font(R.font.urbanistSemiBold.font(size: 14))
                            .foregroundColor(Color.white)
                            .frame(height: 34)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 34)
                    .background(R.color.color_653AE4.color)
                    .cornerRadius(17)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    Button {
                        onTapCancel?()
                    } label: {
                        Text(Rlocalizable.not_allow)
                            .font(R.font.urbanistSemiBold.font(size: 14))
                            .foregroundColor(R.color.color_0F1B2E.color)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 34)
                    .background(Color.white)
                    .cornerRadius(17)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0))
            .frame(width: WIDTH_SCREEN - 68*2)
            .background(Color.white)
            .cornerRadius(12)
        }
        .ignoresSafeArea()
    }
}

struct AccessPhotoPopup_Previews: PreviewProvider {
    static var previews: some View {
        AccessPhotoPopup()
    }
}
