//
//  OnboardingView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var pageIndex: Int = .zero
    @State private var progress: Double = .zero
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $pageIndex) {
                    ForEach(0..<viewModel.listOnboarding.count, id: \.self) { index in
                        let model = viewModel.listOnboarding[index]
                        OnboardingRowView(model: model)
                    }
                }
                .tabViewStyle(.page)
                .animation(.easeInOut, value: pageIndex)
                .disabled(true)
                
                ZStack {
                    let progressValue = (progress + 1)/Double(viewModel.listOnboarding.count)
                    CircularProgressView(progress: progressValue, lineWidth: 3)
                        .frame(width: 65, height: 65)
                    Button(action: { changePage() }) {
                        R.image.ic_next_onboarding.image
                            .renderingMode(.original)
                    }
                }
                .padding(.bottom, 50.0)
                
            }
        }.ignoresSafeArea()
    }
    
    private func changePage() {
        if pageIndex < viewModel.listOnboarding.count - 1 {
            pageIndex += 1
            progress = Double(pageIndex)
        } else {
            UserDefaults.standard.didShowOnboarding = true
            Router.showTabbar()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
