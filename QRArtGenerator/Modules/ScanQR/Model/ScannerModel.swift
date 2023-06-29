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

enum QRScanType: String {
    case wifi  = "WIFI:"
    case mail = "MATMSG:"
    case text = "TEXT:"
    case phone = "PHONE:"
    case url = "url"
}


struct ResultQR {
    var type: QRScanType
    var dictionary: [String: String] = [:]
    var content: String
}
