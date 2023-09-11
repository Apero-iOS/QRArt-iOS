//
//  SplashView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import SwiftUI
import Combine

struct SplashView: View {
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @StateObject private var viewModel = SplashViewModel()
    @State private var subscriptions = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            Image(R.image.image_splash)
                .resizable()
                .scaledToFit()
                .onReceive(timer) { _ in
                    viewModel.isTimerDone.send(true)
                }
        }
        .onAppear {
            setupObserver()
            viewModel.prepareData()
        }
        .onDisappear {
            subscriptions.forEach({$0.cancel()})
        }
    }
    
    private func setupObserver() {
        Publishers
            .Zip3(viewModel.isFetchRemoteDone, viewModel.isTimerDone, viewModel.isCheckIAPDone)
            .sink { isFetchRemoteDone, isTimerDone, isCheckIAPDone in
                if isFetchRemoteDone && isTimerDone && isCheckIAPDone {
                    viewModel.handlePushScreen()
                }
            }.store(in: &subscriptions)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
