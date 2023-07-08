//
//  WifiSecurityMode.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 01/07/2023.
//

import Foundation
import RealmSwift

enum WifiSecurityMode: Int, CaseIterable, PersistableEnum {
    case wep = 1
    case wpa = 2
    case wpa2 = 3
    
    var title: String {
        return String(describing: self).uppercased()
    }
}
