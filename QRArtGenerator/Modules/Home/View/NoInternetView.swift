//
//  NoInternetView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 22/08/2023.
//

import SwiftUI

struct NoInternetView: View {
    
    var tryAgainBlock: VoidBlock?
    var body: some View {
        VStack(spacing: 10) {
            Image(R.image.img_no_internet)
            Text(Rlocalizable.whoops)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.beVietnamProSemiBold.font(size: 16))
            Text(Rlocalizable.no_internet)
                .multilineTextAlignment(.center)
                .foregroundColor(R.color.color_6A758B.color)
                .font(R.font.beVietnamProRegular.font(size: 13))
                .padding(.horizontal, 38)
            Button(Rlocalizable.try_again(), action: {
                tryAgainBlock?()
            })
                .foregroundColor(Color.white)
                .frame(width: 156, height: 40, alignment: .center)
                .background(R.color.color_653AE4.color)
                .cornerRadius(100)
        }
    }
}

struct NoInternetView_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetView()
    }
}
