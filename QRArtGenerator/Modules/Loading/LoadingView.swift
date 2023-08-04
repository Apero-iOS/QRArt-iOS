//
//  LoadingView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

struct LoadingView: View {
    
    @State var scale: CGFloat = 0.75
    @State var textStr: String = "Generating..."
    @State var moveDown: Bool = false
    @State var isShowSub: Bool = false
    @Binding var isDismiss: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            LottieView(lottieFile: R.file.loadingJson.name)
            Button {
                isShowSub = true
            } label: {
                Text("Speed up")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(R.color.color_1B232E.color)
        .fullScreenCover(isPresented: $isShowSub, onDismiss: {
            if isDismiss {
                dismiss()
            }
        }) {
            IAPView(source: .generateButton)
        }
        .onChange(of: isDismiss) { newValue in
            if newValue, !isShowSub {
                dismiss()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isDismiss: .constant(false))
    }
}
