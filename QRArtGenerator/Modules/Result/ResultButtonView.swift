//
//  ResultButtonView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 03/07/2023.
//

import SwiftUI

enum ResultButtonType: CaseIterable {
    case download
    case download4k
    case regenerate
    case share
    
    var image: Image {
        switch self {
        case .download:
            return R.image.ic_download.image
        case .download4k:
            return R.image.ic_download_4k.image
        case .regenerate:
            return R.image.ic_regenerate.image
        case .share:
            return R.image.ic_share_qr.image
        }
    }
    
    var title: String {
        switch self {
        case .download:
            return Rlocalizable.download()
        case .download4k:
            return Rlocalizable.download_4k()
        case .regenerate:
            return Rlocalizable.regenerate()
        case .share:
            return Rlocalizable.share_qr()
        }
    }
}

struct ResultButtonView: View {
    @State var typeButton: ResultButtonType = .download4k
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button {
            onTap?()
        } label: {
            ZStack(alignment: .topTrailing) {
                HStack(alignment: .center, spacing: 8) {
                    typeButton.image
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(typeButton.title)
                        .foregroundColor((typeButton != .download4k) ? Color.black : Color.white)
                        .font(R.font.urbanistSemiBold.font(size: 14))
                }
                .frame(width: WIDTH_SCREEN/2 - 8 - 40, height: 48)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                .background((typeButton != .download4k) ? R.color.color_F7F7F7.color : R.color.color_653AE4.color)
                .cornerRadius(24)
                .border(radius: 24,
                        color: (typeButton != .download4k) ? R.color.color_EAEAEA.color : R.color.color_D8CEF8.color,
                        width: (typeButton != .download4k) ? 1 : 8)
                if typeButton == .download4k {
                    R.image.ic_sub.image
                        .offset(x: -5, y: -5)
                }
            }
            
        }
    }
}

struct ResultButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ResultButtonView()
    }
}
