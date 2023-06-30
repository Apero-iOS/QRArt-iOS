//
//  Constants.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 26/06/2023.
//

import Foundation
import UIKit

var Rlocalizable: _R.string.localizable {
    get {
        return R.string.localizable(preferredLanguages: [LocalizationSystem.sharedInstance.getLanguage()])
    }
}
let HEIGHT_SCREEN = UIScreen.main.bounds.height
let WIDTH_SCREEN = UIScreen.main.bounds.width
let TIME_OUT: TimeInterval = 120
let APP_NAME = "QR_Art_Generator_IOS"
