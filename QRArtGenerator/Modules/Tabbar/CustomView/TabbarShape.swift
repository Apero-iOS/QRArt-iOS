//
//  TabbarShape.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 27/06/2023.
//

import SwiftUI

struct TabBarShape: Shape {
    
    struct Cons {
        static let curveDepth: CGFloat = 28
        static let curveRadius: CGFloat = 30
    }

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let mid = rect.width / 2
            path.move(to: CGPoint(x: mid - Cons.curveRadius * 2, y: 0))
            
            let to1 = CGPoint(x: mid, y: Cons.curveDepth)
            let control1 = CGPoint(x: mid - Cons.curveRadius, y: 0)
            let control2 = CGPoint(x: mid - Cons.curveRadius, y: Cons.curveDepth)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            
            let to2 = CGPoint(x: mid + Cons.curveRadius * 2, y: 0)
            let control3 = CGPoint(x: mid + Cons.curveRadius, y: Cons.curveDepth)
            let control4 = CGPoint(x: mid + Cons.curveRadius, y: 0)
            
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}

struct TabBarShape_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
