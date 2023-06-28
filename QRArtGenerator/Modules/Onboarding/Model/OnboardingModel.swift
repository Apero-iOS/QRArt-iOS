//
//  OnboardingModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import Foundation
import SwiftUI

struct OnboardingModel: Identifiable {
    var id = UUID()
    var image: Image?
    var title: String?
    var content: String?
    
    static let example = OnboardingModel(image: R.image.img_onboarding_1.image, title: Rlocalizable.title_onboarding_1(), content: Rlocalizable.content_onboarding_1())
}
