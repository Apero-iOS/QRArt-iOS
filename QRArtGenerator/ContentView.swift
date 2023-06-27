//
//  ContentView.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            R.image.home_ic.image
            Text(Rlocalizable.ok)
                .font(R.font.urbanistBlack.font(size: 20))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
