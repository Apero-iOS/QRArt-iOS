//
//  ScannerModel.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import Foundation

enum CameraPermission: String {
    case idle = "Not Determined"
    case approve = "Access Apperove"
    case denied = "Access Denied"
}

enum QRActionType {
    case connectWifi
    case copyText
    case phoneMessage
    case phoneCall
    case openMail
    case openUrl
    
    var title: String {
        switch self {
        case .connectWifi:
            return Rlocalizable.access_wifi()
        case .copyText:
            return Rlocalizable.copy_text()
        case .phoneMessage:
            return Rlocalizable.phone_message()
        case .phoneCall:
            return Rlocalizable.phone_call()
        case .openMail:
            return Rlocalizable.open_mail()
        case .openUrl:
            return Rlocalizable.open_link()
        }
    }
}

enum QRScanType: String {
    case wifi  = "WIFI:"
    case mail = "MATMSG:"
    case text = "TEXT:"
    case phone = "PHONE:"
    case url = "url"
    
    var actions: [QRActionType] {
        switch self {
        case .wifi:
            return [.connectWifi]
        case .mail:
            return [.openMail]
        case .text:
            return [.copyText]
        case .phone:
            return [.phoneMessage, .phoneCall]
        case .url:
            return [.openUrl]
        }
    }
}


struct ResultQR {
    var type: QRScanType
    var dictionary: [String: String] = [:]
    var content: String
}
