//
//  QRHelper.swift
//  QRArtGenerator
//
//  Created by khac tao on 30/06/2023.
//

import Foundation
import NetworkExtension
import SwiftUI


struct QRHelper {
    
    static func parseResultQR(text: String) -> ResultQR {
        var arrydict = text.components(separatedBy: ";")
        var result = ResultQR(type: .text, content: text, title: text)
        if arrydict.count > 1 {
            if arrydict[0].starts(with: QRScanType.wifi.rawValue) {
                // QR wifi
                result.type = .wifi
                arrydict[0] = arrydict[0].replacingOccurrences(of: QRScanType.wifi.rawValue, with: "")
                arrydict.forEach { string in
                    let dicArry = string.components(separatedBy: ":")
                    if dicArry.count == 2 {
                        if dicArry[0] == "S" {
                            result.title = dicArry[1]
                        }
                        result.dictionary.updateValue(dicArry[1], forKey: dicArry[0])
                    }
                }
            } else if arrydict.first!.starts(with: QRScanType.mail.rawValue) {
                //QR mail
                arrydict[0] = arrydict[0].replacingOccurrences(of: QRScanType.mail.rawValue, with: "")
                result.type = .mail
                arrydict.forEach { string in
                    let dicArry = string.components(separatedBy: ":")
                    if dicArry.count == 2 {
                        if dicArry[0] == "TO" {
                            result.title = dicArry[1]
                        }
                        result.dictionary.updateValue(dicArry[1], forKey: dicArry[0])
                    }
                }
            } else {
                // QR unknow
                result.type = .text
            }
        } else {
            if QRHelper.isValidPhone(phone: text) {
                result.type = .phone
            } else if QRHelper.verifyUrl(urlString: text) {
                result.type = .url
            } else {
                result.type = .text
            }
        }
        return result
    }
    
    static func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    static func openUrl(urlString: String?) {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                UIApplication.shared.open(url as URL)
            }
        }
    }
    
    static func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    
    static func connectWifi(data: WifiData, completion: ((Bool, String) -> Void)?) {
        let configuration = NEHotspotConfiguration.init(ssid: data.ssid, passphrase: data.password, isWEP: data.type == "WEP")
        configuration.joinOnce = true
        NEHotspotConfigurationManager.shared.apply(configuration) {
            (error) in
            if error != nil {
                if let errorStr = error?.localizedDescription {
                    print("Error Information:\(errorStr)")
                }
                if (error?.localizedDescription == "already associated.") {
                    completion?(true, Rlocalizable.connected())
                } else {
                    completion?(false, Rlocalizable.no_connected())
                }
            } else {
                completion?(true, Rlocalizable.connected())
            }
        }
    }
    
    static func sendMail(data: MailData) {
        let encodedParams = "subject=\(data.subject)&body=\(data.body)"
        let urlString = "mailto:\(data.to)?\(encodedParams)"
        QRHelper.openUrl(urlString: urlString)
    }
    
    static func genQR(text: String) -> UIImage? {
        let data = text.data(using: .ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                let uiImage = UIImage(ciImage: output)
                return uiImage
            }
        }
        return nil
    }
    
}

