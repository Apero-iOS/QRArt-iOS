//
//  Constants.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 26/06/2023.
//

import Foundation
import UIKit

public typealias VoidBlock = () -> Void
public typealias BoolBlock = (Bool) -> Void
public typealias StringBlock = (String) -> Void
public typealias UrlBlock = (URL?) -> Void
public typealias FloatBlock = (Float) -> Void
public typealias IntBlock = (Int) -> Void

var Rlocalizable: _R.string.localizable {
    get {
        return R.string.localizable(preferredLanguages: [LocalizationSystem.sharedInstance.getLanguage()])
    }
}
let HEIGHT_SCREEN = UIScreen.main.bounds.height
let WIDTH_SCREEN = UIScreen.main.bounds.width
let TIME_OUT: TimeInterval = 120
let APP_NAME = "QR_Art_Generator_IOS"


struct Constants {
    static let dummyQRs = [QRDetailItem(id: "0", name: "QR Art for Youtube Alec benjamin", createdDate: Date().lastMonth, qrImage: R.image.image_test()!, type: .text, groupType: .basic, templateId: "0"),
                           QRDetailItem(id: "1", name: "Make your QR code become more special with our AI - service!", createdDate: Date().yesterday, qrImage: R.image.image_test()!, type: .email, groupType: .social, templateId: "0"),
                           QRDetailItem(id: "2", name: "Show the influence of prompts on image generation.", createdDate: Date(), qrImage: R.image.image_test()!, type: .instagram, groupType: .other, templateId: "0")]
}
