//
//  CircularProgressView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat
    
     let underLineColor: Color = R.color.color_EAEAEA.color
    
     let aboveLineColor: LinearGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: R.color.color_6427C8.color, location: 0.00),
            Gradient.Stop(color: R.color.color_E79CB7.color, location: 1.00),
        ],
        startPoint: UnitPoint(x: 0, y: 1),
        endPoint: UnitPoint(x: 1, y: 0)
    )
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    underLineColor,
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    aboveLineColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.5, lineWidth: 10)
    }
}
