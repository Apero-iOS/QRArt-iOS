//
//  QRItemDB.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 01/07/2023.
//

import Foundation
import RealmSwift

class QRItemDB: Object {
    @Persisted(primaryKey: true) var ID: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var createdDate: Date = Date()
    @Persisted var type: QRType
    @Persisted var groupType: QRGroupType
    @Persisted var templateId: String = ""
    @Persisted var urlString: String
    
    // Contact
    @Persisted var contactName: String
    @Persisted var phoneNumber: String
    
    // Text
    @Persisted var text: String
    
    // Email
    @Persisted var emailAddress: String
    @Persisted var emailSubject: String
    @Persisted var emailDescription: String
    
    // Wifi
    @Persisted var wfSsid: String
    @Persisted var wfPassword: String
    @Persisted var wfSecurityMode: WifiSecurityMode
    
    // Paypal
    @Persisted var paypalAmount: Double
    
    // Advanced
    @Persisted var prompt: String
    @Persisted var negativePrompt: String
    @Persisted var guidance: Int
    @Persisted var contronetScale: Int
    @Persisted var steps: Int
    
    
    
    func convertToDetailItem() -> QRDetailItem {
        let image = FileManagerUtil.shared.getImage(from: ID)
        return QRDetailItem(id: ID,
                            name: name,
                            createdDate: createdDate,
                            qrImage: image,
                            type: type,
                            groupType: groupType,
                            templateId: templateId,
                            urlString: urlString,
                            contactName: contactName,
                            phoneNumber: phoneNumber,
                            text: text,
                            emailAddress: emailAddress,
                            emailSubject: emailSubject,
                            emailDescription: emailDescription,
                            wfSsid: wfSsid,
                            wfPassword: wfPassword,
                            wfSecurityMode: wfSecurityMode,
                            paypalAmount: paypalAmount,
                            prompt: prompt,
                            negativePrompt: negativePrompt,
                            guidance: guidance,
                            contronetScale: contronetScale,
                            steps: steps)
    }
}

// MARK: - Realm func
extension QRItemDB {
    func copyObject() -> QRItemDB {
        let copy = QRItemDB()
        copy.ID = ID
        copy.name = name
        copy.createdDate = createdDate
        copy.type = type
        copy.groupType = groupType
        copy.templateId = templateId
        copy.urlString = urlString
        copy.contactName = contactName
        copy.phoneNumber = phoneNumber
        copy.text = text
        copy.emailAddress = emailAddress
        copy.emailSubject = emailSubject
        copy.emailDescription = emailDescription
        copy.wfSsid = wfSsid
        copy.wfPassword = wfPassword
        copy.wfSecurityMode = wfSecurityMode
        copy.paypalAmount = paypalAmount
        copy.prompt = prompt
        copy.negativePrompt = negativePrompt
        copy.guidance = guidance
        copy.contronetScale = contronetScale
        copy.steps = steps
        return copy
    }
    
    func duplicateObject() -> QRItemDB {
        let duplicate = QRItemDB()
        duplicate.name = name
        duplicate.createdDate = createdDate
        duplicate.type = type
        duplicate.groupType = groupType
        duplicate.templateId = templateId
        duplicate.urlString = urlString
        duplicate.contactName = contactName
        duplicate.phoneNumber = phoneNumber
        duplicate.text = text
        duplicate.emailAddress = emailAddress
        duplicate.emailSubject = emailSubject
        duplicate.emailDescription = emailDescription
        duplicate.wfSsid = wfSsid
        duplicate.wfPassword = wfPassword
        duplicate.wfSecurityMode = wfSecurityMode
        duplicate.paypalAmount = paypalAmount
        duplicate.prompt = prompt
        duplicate.negativePrompt = negativePrompt
        duplicate.guidance = guidance
        duplicate.contronetScale = contronetScale
        duplicate.steps = steps
        return duplicate
    }
}
