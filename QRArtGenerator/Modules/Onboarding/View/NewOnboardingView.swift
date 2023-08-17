//
//  NewOnboardingView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 14/08/2023.
//

import SwiftUI

struct NewOnboardingView: View {
    
    @State private var showSub: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(R.image.new_onboarding)
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack {
                Text(Rlocalizable.discover_wow_qr_art)
                    .font(R.font.beVietnamProBold.font(size: 22))
                    .foregroundColor(R.color.color_222222.color)
                    .padding(.bottom, 8)
                Text(Rlocalizable.content_onboarding)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 32)
                
                Button {
                    FirebaseAnalytics.logEvent(type: .onboarding_click)
                    UserDefaults.standard.didShowOnboarding = true
                    if UserDefaults.standard.isUserVip {
                        Router.showTabbar()
                    } else {
                        showSub = true
                    }
                } label: {
                    HStack {
                        Text(Rlocalizable.continue)
                            .foregroundColor(.white)
                            .font(R.font.beVietnamProSemiBold.font(size: 14))
                    }
                    .frame(width: UIScreen.screenWidth - 48, height: 42)
                    .background(R.color.color_653AE4.color)
                    .cornerRadius(24)
                }
                .padding(.bottom, 77)

            }
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showSub) {
            IAPView(isAfterOnboarding: true) {
                Router.showTabbar()
            }
        }
        .onAppear {
            FirebaseAnalytics.logEvent(type: .onboarding_view)
            PermissionTrackkingHelper.requestPermissionTrackking()
        }
    }
}

struct NewOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        NewOnboardingView()
    }
}
