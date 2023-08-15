//
//  PopupConfirmSaveQR.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 14/08/2023.
//

import SwiftUI
import MobileAds

struct PopupConfirmSaveQR: View {
    
    @State var isLoadAds: Bool = true
    
    var isShowAds: Bool {
        return !UserDefaults.standard.isUserVip && RemoteConfigService.shared.bool(forKey: .native_resultback)
    }
    
    var onTapOk: VoidBlock? = nil
    var onTapNo: VoidBlock? = nil
    
    var body: some View {
        VStack {
            Text(Rlocalizable.exit)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
                .padding(.top, 24)
            Text(Rlocalizable.confirm_exit)
                .font(R.font.beVietnamProRegular.font(size: 12))
                .foregroundColor(.black.opacity(0.8))
            HStack(spacing: 10) {
                Button(Rlocalizable.yes()) {
                    onTapOk?()
                }
                .font(R.font.beVietnamProSemiBold.font(size: 16))
                .foregroundColor(R.color.color_000000.color.opacity(0.8))
                .frame(maxWidth: .infinity, maxHeight: 34)
                .background(.white)
                .border(radius: 100, color: R.color.color_000000.color.opacity(0.8), width: 1)
                
                Button(Rlocalizable.no()) {
                    onTapNo?()
                }
                .font(R.font.beVietnamProSemiBold.font(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 34)
                .background(R.color.color_653AE4.color)
                .cornerRadius(100)
            }
            .padding(.horizontal, 45)
            .padding(.bottom, 20)
            if isShowAds && isLoadAds {
                AdNativeView(adUnitID: AdUnitID.native_resultback, type: .medium, blockNativeFaild: {
                    isLoadAds = false
                })
                .frame(height: 240)
            }
        }
        .background(.white)
        .cornerRadius(12)
        .padding(.horizontal, 24)

    }
}

struct PopupConfirmSaveQR_Previews: PreviewProvider {
    static var previews: some View {
        PopupConfirmSaveQR()
    }
}
