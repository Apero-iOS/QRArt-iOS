//
//  SplashView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import SwiftUI

struct SplashView: View {
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Image(R.image.image_splash)
                .resizable()
                .scaledToFill()
                .onReceive(timer) { _ in
                    Router.showOnboarding()
                }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
