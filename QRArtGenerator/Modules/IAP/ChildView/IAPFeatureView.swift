//
//  IAPFeatureView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 02/07/2023.
//

import SwiftUI

struct IAPFeatureView: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(R.image.iap_feature_star_ic)
            
            Text(title)
                .font(R.font.beVietnamProMedium.font(size: 14))
                .foregroundColor(R.color.color_1B232E.color)
        }
    }
}

struct IAPFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        IAPFeatureView(title: Rlocalizable.no_advertisements())
    }
}
