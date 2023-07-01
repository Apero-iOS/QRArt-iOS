//
//  CreateQRInput.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 01/07/2023.
//

import Foundation

struct CreateQRInput {
    var type: QRType = .website
    var name: String = ""
    var link: String?
    var contactName: String?
    var phoneNumber: String?
    var text: String?
    var emailTo: String?
    var subject: String?
    var emailDesc: String?
    var ssid: String?
    var password: String?
    var securityMode: String?
    var amount: String?

}
