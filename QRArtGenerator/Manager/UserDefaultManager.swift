//
//  UserDefaultManager.swift
//  Base-IOS
//
//  Created by Đinh Văn Trình on 28/06/2022.
//

import UIKit

extension UserDefaults {
    
    var isUserVip: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.Keys.KEY_USER_VIP)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.KEY_USER_VIP)
            InappManager.share.didPaymentSuccess.send(newValue)
        }
    }
    
    var openAppCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Keys.OPEN_APP_COUNT)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.OPEN_APP_COUNT)
        }
    }
    
    var didShowOnboarding: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.Keys.DID_SHOW_ONBOARDING)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.DID_SHOW_ONBOARDING)
        }
    }
    
    var isFirstLanguage: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.Keys.FIRST_LANGUAGE)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.FIRST_LANGUAGE)
        }
    }
    
    var generatePerDay: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Keys.GENERATE_PER_DAY)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.GENERATE_PER_DAY)
        }
    }
    
    var regeneratePerDay: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.Keys.REGENERATE_PER_DAY)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.REGENERATE_PER_DAY)
        }
    }
    
    var lastDayOpenApp: Date? {
        get {
            return UserDefaults.standard.value(forKey: Constants.Keys.KEY_LAST_DAY_OPEN_APP) as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.Keys.KEY_LAST_DAY_OPEN_APP)
        }
    }
}
