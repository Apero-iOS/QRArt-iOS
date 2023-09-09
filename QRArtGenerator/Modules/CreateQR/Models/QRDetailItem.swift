//
//  QRDetailItem.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 01/07/2023.
//

import SwiftUI

struct QRDetailItem: QRItem {
    var id: String = UUID().uuidString
    var name: String = ""
    var createdDate: Date = Date()
    var qrImage: UIImage = UIImage()
    var baseUrl: String?
    var type: QRType = .website
    var groupType: QRGroupType = .basic
    var templateId: String = ""
    var urlString: String = ""
    var templateQRName: String = ""
    var createType: CreateQRType = .custom
    
    // Contact
    var contactName: String = ""
    var phoneNumber: String = ""
    
    // Text
    var text: String = ""
    
    // Email
    var emailAddress: String = ""
    var emailSubject: String = ""
    var emailDescription: String = ""
    
    // Wifi
    var wfSsid: String = ""
    var wfPassword: String = ""
    var wfSecurityMode: WifiSecurityMode = .wep
    var indexWfSecurityMode: Int = 1
    
    // Paypal
    var paypalAmount: String = ""
    
    // Advanced
    var prompt: String = ""
    var negativePrompt: String = ""
    var guidance: Double = 10
    var contronetScale: Double = 10
    var steps: Double = 3
    
    func convertToDB(isNew: Bool = true) -> QRItemDB {
        let object = QRItemDB()
        if !isNew {
            object.ID = id
        }
        object.name = name
        object.createdDate = createdDate
        object.type = type
        object.groupType = groupType
        object.templateId = templateId
        object.urlString = urlString
        object.contactName = contactName
        object.phoneNumber = phoneNumber
        object.text = text
        object.emailAddress = emailAddress
        object.emailSubject = emailSubject
        object.emailDescription = emailDescription
        object.wfSsid = wfSsid
        object.wfPassword = wfPassword
        object.wfSecurityMode = wfSecurityMode
        object.paypalAmount = paypalAmount
        object.prompt = prompt
        object.negativePrompt = negativePrompt
        object.guidance = Int(guidance)
        object.contronetScale = Int(contronetScale)
        object.steps = Int(steps)
        object.baseUrl = baseUrl
        object.templateQRName = templateQRName
        object.createType = createType
        return object
    }
    
    func duplicate() -> QRDetailItem {
        var obj = QRDetailItem()
        obj.type = type
        obj.prompt = prompt
        obj.negativePrompt = negativePrompt
        obj.baseUrl = baseUrl
        obj.templateQRName = templateQRName
        obj.createType = createType
        return obj
    }
}
