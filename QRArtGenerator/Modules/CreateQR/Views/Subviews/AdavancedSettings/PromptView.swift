//
//  PromptView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 29/06/2023.
//

import SwiftUI
import MobileAds

struct PromptView: View {
    @Binding var prompt: String
    @State var countAds: Int = 1
    var oldPrompt: String
    var title: String = ""
    var subTitle: String = ""
    
    private var isShowAdsInter: Bool {
        return RemoteConfigService.shared.number(forKey: .inter_inspire) > .zero && !UserDefaults.standard.isUserVip
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(R.font.urbanistSemiBold.font(size: 14))
                        .foregroundColor(R.color.color_1B232E.color)
                    Text(subTitle)
                        .font(R.font.urbanistMedium.font(size: 12))
                        .foregroundColor(R.color.color_6A758B.color)
                }
                Spacer()
                Button {
                    showAdsInter()
                } label: {
                    R.image.ic_pen.image
                }
            }
            TextField(Rlocalizable.enter_prompt(), text: $prompt)
                .frame(height: 100, alignment: .top)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                .font(R.font.urbanistRegular.font(size: 14))
        }
        .onAppear {
            createIdAds()
        }
    }
    
    private func showAdsInter() {
        if isShowAdsInter, countAds%RemoteConfigService.shared.number(forKey: .inter_inspire) == .zero {
            AdMobManager.shared.showIntertitial(unitId: .inter_inspire, isSplash: false, blockDidDismiss:  {
                prompt = oldPrompt
                countAds += 1
            })
        } else {
            prompt = oldPrompt
            countAds += 1
        }
    }
    
    private func createIdAds() {
        if isShowAdsInter {
            AdMobManager.shared.createAdInterstitialIfNeed(unitId: .inter_inspire)
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView(prompt: .constant(""), oldPrompt: "")
    }
}
