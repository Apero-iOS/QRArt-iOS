//
//  ItemTemplateView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct ItemTemplateView: View {
    var name: String = ""
    
    var body: some View {
        VStack {
            Image(R.image.tuan)
            Text(name)
                .font(R.font.urbanistMedium.font(size: 12))
        }
        .frame(maxWidth: 103, maxHeight: 124)
    }
}

struct ItemTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        ItemTemplateView(name: "Hello")
            .previewLayout(.sizeThatFits)
        
    }
}
