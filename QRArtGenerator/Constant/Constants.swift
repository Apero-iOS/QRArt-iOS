//
//  Constants.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 26/06/2023.
//

import Foundation

var Rlocalizable: _R.string.localizable {
    get {
        return R.string.localizable(preferredLanguages: [LocalizationSystem.sharedInstance.getLanguage()])
    }
}
