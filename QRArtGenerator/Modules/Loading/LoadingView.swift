//
//  LoadingView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            LottieView(lottieFile: R.file.loadingJson.name)
        }
        .background(R.color.color_1B232E.color)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
