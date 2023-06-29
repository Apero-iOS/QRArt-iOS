//
//  HistoryCategoryListView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

struct HistoryCategoryListView: View {
    
    @Binding var caterories: [String]
    @State var selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                ForEach(caterories.indices, id: \.self) { i in
                    Text(caterories[i])
                        .font(R.font.urbanistSemiBold.font(size: 14))
                        .foregroundColor(selectedIndex == i ? .white : R.color.color_6A758B.color)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(selectedIndex == i ? R.color.color_653AE4.color : R.color.color_F7F7F7.color)
                        .border(radius: 20, color: selectedIndex == i ? R.color.color_D1C4F7.color : .clear, width: 4)
                        .frame(height: 40)
                        .onTapGesture {
                            selectedIndex = i
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HistoryCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCategoryListView(caterories: .constant(["Basic", "Social Media"]), selectedIndex: 0)
    }
}
