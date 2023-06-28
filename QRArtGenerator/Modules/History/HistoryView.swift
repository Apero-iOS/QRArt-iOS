//
//  HistoryView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    Image(R.image.history_logo_ic)
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    LottieView(lottieFile: R.file.crownJson.name)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            // TODO: Show iap
                        }
                }
                .frame(height: 48)
                
                Text(Rlocalizable.history())
                    .font(R.font.urbanistBold.font(size: 28))
                    .foregroundColor(R.color.color_1B232E.color)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
//                emptyView
                listView
            }
            .hideNavigationBar()
        }
    }
    
    @ViewBuilder var emptyView: some View {
        Spacer()
            .frame(height: HEIGHT_SCREEN / 20)
        
        Image(R.image.history_empty_ic)
            .aspectRatio(contentMode: .fit)
        
        VStack(spacing: 24) {
            VStack(alignment: .center, spacing: 4) {
                Text(Rlocalizable.artify_your_qr_codes)
                    .font(R.font.urbanistBold.font(size: 18))
                    .foregroundColor(R.color.color_1B232E.color)
                
                Text(Rlocalizable.no_qrs_created_yet)
                    .font(R.font.urbanistRegular.font(size: 16))
                    .padding(.horizontal, 20)
                    .foregroundColor(R.color.color_6A758B.color)
                    .multilineTextAlignment(.center)
            }
            
            Button(Rlocalizable.create_qr()) {
                // TODO: show create QR
            }
            .font(R.font.urbanistSemiBold.font(size: 14))
            .frame(width: 156, height: 34)
            .foregroundColor(Color.white)
            .background(R.color.color_653AE4.color)
            .clipShape(Capsule())
        }
        .opacity(1)
        
        Spacer()
    }
    
    @ViewBuilder var listView: some View {
        HStack(spacing: 12) {
            Image(R.image.search_ic)
                .frame(width: 24)
                .padding(.leading, 12)
            
            Text(Rlocalizable.search_qr_name())
                .font(R.font.urbanistRegular.font(size: 14))
                .foregroundColor(R.color.color_6A758B.color)
            
            Spacer()
        }
        .frame(height: 40)
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .stroke(R.color.color_EAEAEA.color)
        )
        .padding(.horizontal, 20)
        .onTapGesture {
            // TODO: show search
        }
        
        Spacer()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}
