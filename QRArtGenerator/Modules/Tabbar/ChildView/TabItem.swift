//
//  TabItem.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI

struct TabItem: View {
    
    let width: CGFloat
    @State var tab: TabbarEnum
    @Binding var selectedTab: TabbarEnum
    var scanCallBack: ((TabbarEnum) -> Void)?
    var body: some View {
        ZStack {
            VStack {
                if tab == .ai {
                    TabbarPrimaryButton()
                        .padding(.bottom, 16)
                    
                    Text(tab.title)
                        .font(R.font.beVietnamProBold.font(size: 14))
                        .foregroundStyle(
                            .linearGradient(colors: [R.color.color_6427C8.color, R.color.color_E79CB7.color],
                                            startPoint: .leading,
                                            endPoint: .trailing)
                        )
                        .lineLimit(1)
                    
                } else {
                    (tab == selectedTab ? tab.selectedIcon : tab.icon)
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 10)
                    
                    Text(tab.title)
                        .font(R.font.beVietnamProSemiBold.font(size: 14))
                        .foregroundColor(tab == selectedTab ? R.color.color_653AE4.color : R.color.color_9EABB9.color)
                        .lineLimit(1)
                }
            }
            .frame(width: width)
            .padding(.bottom, 8)
            .onTapGesture {
                if tab == .scan || tab == .ai {
                    scanCallBack?(tab)
                } else {
                    selectedTab = tab
                }
               
            }
        }
    }
}

struct TabItem_Previews: PreviewProvider {
    static var previews: some View {
        TabItem(width: 50,
                tab: .ai,
                selectedTab: .constant(.home))
    }
}
