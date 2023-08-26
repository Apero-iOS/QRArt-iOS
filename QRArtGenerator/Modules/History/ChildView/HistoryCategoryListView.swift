//
//  HistoryCategoryListView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 28/06/2023.
//

import SwiftUI

struct HistoryCategoryListView: View {
    
    @Binding var caterories: [HistoryCategory]
    @Binding var selectedCate: HistoryCategory?
    var onSelectCategory: ((HistoryCategory) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                ForEach(caterories, id: \.type) { cate in
                    Text(titleOf(cate: cate) + " (\(cate.count))")
                        .font(R.font.beVietnamProSemiBold.font(size: 14))
                        .foregroundColor(selectedCate == cate ? .white : R.color.color_6A758B.color)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(selectedCate == cate ? R.color.color_653AE4.color : R.color.color_F7F7F7.color)
                        .border(radius: 20, color: selectedCate == cate ? R.color.color_D1C4F7.color : .clear, width: 4)
                        .frame(height: 40)
                        .onTapGesture {
                            onSelectCategory?(cate)
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    func titleOf(cate: HistoryCategory) -> String {
        cate.type == nil ? Rlocalizable.all() : (cate.type?.title ?? "")
    }
}

struct HistoryCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCategoryListView(caterories: .constant([HistoryCategory(type: nil, count: 3)]),
                                selectedCate: .constant(HistoryCategory(type: nil, count: 3)),
                                onSelectCategory: nil)
    }
}
