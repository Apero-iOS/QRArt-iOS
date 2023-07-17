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
    
    var body: some View {
        ZStack {
            LottieView(lottieFile: R.file.loadingJson.name)
            HStack(spacing: 2) {
                let textArr = textStr.map { String($0) }
                ForEach(0..<textArr.count, id: \.self) { index in
                    Text(textArr[index])
                        .font(R.font.urbanistSemiBold.font(size: 16))
                        .foregroundColor(Color(red: 0.98, green: 0.76, blue: 0.16))
                        .scaleEffect(scale)
//                        .offset(x: 0, y: self.moveDown ? 3 : 0) 
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index)*0.1),
                            value: UUID()
                        )
                        .onAppear {
                            withAnimation {
                                scale = 1
//                                moveDown.toggle()
                            }
                        }
                }
            }
            .padding(.top, 100)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(R.color.color_1B232E.color)
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
