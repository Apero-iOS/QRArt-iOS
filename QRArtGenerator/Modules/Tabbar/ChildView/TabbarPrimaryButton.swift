//
//  TabbarPrimaryButton.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI
import Lottie

struct TabbarPrimaryButton: View {
    
    private let size: CGFloat = 56
    @State private var isRotating = 0.0
    
    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(
//                    LinearGradient(colors: [R.color.color_6427C8.color, R.color.color_E79CB7.color], startPoint: .bottomLeading, endPoint: .topTrailing),
//                    lineWidth: 5
//                )
//                .background(Color.white)
//                .cornerRadius(size / 2)
//                .rotationEffect(.degrees(isRotating))
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        withAnimation(
//                            .linear(duration: 1)
//                            .speed(1)
//                            .repeatForever(autoreverses: false))
//                        {
//                            isRotating = 360.0
//                        }
//                    }
//                }
//
//            LottieView(lottieFile: R.file.ai_tabJson.name)
//                .frame(width: size * 0.6)
//        }
        Image(R.image.ic_scan.name)
        .frame(width: size, height: size)
        .shadow(color: R.color.color_E5AEFF_45.color, radius: 16, x: 0, y: 6)
    }
}

struct TabbarPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        TabbarPrimaryButton()
    }
}
