//
//  Constants.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 26/06/2023.
//

import Foundation
import UIKit
import MobileAds

public typealias VoidBlock = () -> Void
public typealias BoolBlock = (Bool) -> Void
public typealias StringBlock = (String) -> Void
public typealias UrlBlock = (URL?) -> Void
public typealias FloatBlock = (Float) -> Void
public typealias IntBlock = (Int) -> Void

var realmVersion: UInt64 = 3
var Rlocalizable: _R.string.localizable {
    get {
        return R.string.localizable(preferredLanguages: [LocalizationSystem.sharedInstance.getLanguage()])
    }
}
let HEIGHT_SCREEN = UIScreen.main.bounds.height
let WIDTH_SCREEN = UIScreen.main.bounds.width
let TIME_OUT: TimeInterval = 60
let APP_NAME = "QR_Art_Generator_IOS"
let APP_ID = "6450879455"



struct Constants {
    static let dummyQRs = [QRDetailItem()]
    
    struct APISignature {
        static let keyId = "FqipUc0wyy"
    }
    
    struct Keys {
        static let KEY_USER_VIP = "KEY_USER_VIP"
        static let OPEN_APP_COUNT = "OPEN_APP_COUNT"
        static let GENERATE_QR_COUNT = "GENERATE_QR_COUNT"
        static let DID_SHOW_ONBOARDING = "DID_SHOW_ONBOARDING"
        static let FIRST_LANGUAGE = "FIRST_LANGUAGE"
        static let GENERATE_PER_DAY = "GENERATE_PER_DAY"
        static let REGENERATE_PER_DAY = "REGENERATE_PER_DAY"
        static let KEY_LAST_DAY_OPEN_APP = "KEY_LAST_DAY_OPEN_APP"
        static let TOOLTIPS_DONE = "TOOLTIPS_DONE"
    }
    
    struct GoogleService {
        #if DEV || STG
        static let ggPlistName = "GoogleService-Info-DEV"
        #else
        static let ggPlistName = "GoogleService-Info"
        #endif
    }
    
    #if DEV || STG
    static let isDev: Bool = true
    #else
    static let isDev: Bool = false
    #endif
    
    static let termUrl = "https://sites.google.com/view/qr-art-code-term-of-service/home"
    static let policyUrl = "https://sites.google.com/view/qr-art-code-privacy-policy/home"
    
    struct Colors {
        static let defaultNativeAdColors = ThemeStyleAds.setBackground(backgroundColor: R.color.color_EAEAEA() ?? UIColor())
    }
}
