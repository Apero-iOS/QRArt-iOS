//
//  IAPCell.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 02/07/2023.
//

import SwiftUI

struct IAPCell: View {
    @State var idType: IAPIdType
    @State var index: Int
    @Binding var selectedIndex: Int
    var onTap: (() -> Void)? = nil
    
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(idType.title)
                        .font(R.font.beVietnamProBold.font(size: 16))
                        .foregroundColor(isBestPrice ? .white : R.color.color_1B232E.color)
                    
                    if isBestPrice {
                        HStack(spacing: 4) {
                            Text(Rlocalizable.popular)
                                .font(R.font.beVietnamProSemiBold.font(size: 12))
                                .foregroundColor(.white)
                                .padding(.leading, 8)
                            
                            Image(R.image.iap_popular_star_ic)
                                .padding(.trailing, 8)
                        }
                        .frame(height: 20)
                        .background(
                            LinearGradient(colors: [R.color.color_FFAC4B.color, R.color.color_F6D210.color],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .cornerRadius(10)
                    }
                }
                
                if idType == .lifetime {
                    Text(Rlocalizable.onetime_payment)
                        .font(R.font.beVietnamProMedium.font(size: 12))
                        .foregroundColor(isBestPrice ? .white : R.color.color_6A758B.color)
                } else if idType.freeday > 0 {
                    HStack(spacing: 8) {
                        Text(Rlocalizable.auto_renewal)
                            .font(R.font.beVietnamProMedium.font(size: 12))
                            .foregroundColor(isBestPrice ? .white : R.color.color_6A758B.color)
                        
                        Circle()
                            .frame(width: 3)
                            .foregroundColor(isBestPrice ? .white : R.color.color_9EABB9.color)
                        
                        Text(Rlocalizable.free_day_trial("\(idType.freeday)"))
                            .font(R.font.beVietnamProMedium.font(size: 12))
                            .foregroundColor(isBestPrice ? .white : R.color.color_6A758B.color)
                    }
                }
            }
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 0))
            
            Spacer()
            
            Text(idType.localizedPrice)
                .font(R.font.beVietnamProBold.font(size: 16))
                .foregroundColor(isBestPrice ? .white : R.color.color_1B232E.color)
                .padding(.trailing, 16)
        }
        .frame(height: 65)
        .background(isBestPrice ? R.color.color_653AE4.color : R.color.color_653AE4_5.color)
        .cornerRadius(12)
        .onTapGesture {
            onTap?()
        }
    }
    
    var isBestPrice: Bool {
        return IAPIdType.checkBestPrice(id: idType.id)
    }
}

struct IAPCell_Previews: PreviewProvider {
    static var previews: some View {
        IAPCell(idType: .month, index: 0, selectedIndex: .constant(0))
    }
}
