//
//  OnboardingViewModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import Foundation
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    public var listOnboarding: [OnboardingModel] = [OnboardingModel(image: R.image.img_onboarding_1.image,
                                                                    title: Rlocalizable.title_onboarding_1(),
                                                                    content: Rlocalizable.content_onboarding_1()),
                                                    OnboardingModel(image: R.image.img_onboarding_2.image,
                                                                    title: Rlocalizable.title_onboarding_2(),
                                                                    content: Rlocalizable.content_onboarding_2()),
                                                    OnboardingModel(image: R.image.img_onboarding_3.image,
                                                                    title: Rlocalizable.title_onboarding_3(),
                                                                    content: Rlocalizable.content_onboarding_3())]
}
