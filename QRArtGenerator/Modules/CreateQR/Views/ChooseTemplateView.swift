//
//  ChooseTemplateView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct ChooseTemplateView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(Rlocalizable.choose_a_template())
                .font(R.font.urbanistSemiBold.font(size: 16))
                .foregroundColor(R.color.color_1B232E.color)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(0..<10) { index in
                        ItemTemplateView(name: "OK")
                    }
                }
            }
            .frame(maxWidth: WIDTH_SCREEN, maxHeight: 124)
        }
        .padding(.leading, 20)
        .frame(maxWidth: WIDTH_SCREEN, maxHeight: 193)
    }
}

struct ChooseTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTemplateView()
            .previewLayout(.sizeThatFits)
    }
}
