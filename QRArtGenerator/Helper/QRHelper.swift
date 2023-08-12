//
//  QRHelper.swift
//  QRArtGenerator
//
//  Created by khac tao on 30/06/2023.
//

import Foundation
import NetworkExtension
import SwiftUI
import Photos
import FBSDKShareKit
import UIKit
import Social

public protocol SocialMediaShareable {
    func image() -> UIImage?
    func url() -> URL?
    func text() -> String?
}


class QRHelper: NSObject {
    static let share = QRHelper()
    var documentController: UIDocumentInteractionController!
    
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
                    if dicArry.count >= 2 {
                        if dicArry[0] == "S" {
                            result.title = dicArry[1]
                        }
                        result.dictionary.updateValue(string.replacingOccurrences(of: dicArry[0]+":", with: ""), forKey: dicArry[0])
                    }
                }
            } else if arrydict.first!.starts(with: QRScanType.mail.rawValue) {
                //QR mail
                arrydict[0] = arrydict[0].replacingOccurrences(of: QRScanType.mail.rawValue, with: "")
                result.type = .mail
                let dicArryBody = text.components(separatedBy: "BODY:")
                if dicArryBody.count == 2 {
                    result.dictionary.updateValue(String(dicArryBody[1].dropLast()), forKey: "BODY")
                    let dicArrySUB = dicArryBody[0].components(separatedBy: "SUB:")
                    if dicArrySUB.count == 2 {
                        result.dictionary.updateValue(String(dicArrySUB[1].dropLast()), forKey: "SUB")
                        
                        let dicArryTO = dicArrySUB[0].components(separatedBy: "TO:")
                        result.dictionary.updateValue(String(dicArryTO[1].dropLast()), forKey: "TO")
                        result.title = String(dicArryTO[1].dropLast())
                    }
                }
                
            } else {
                // QR unknow
                result.type = .text
            }
        } else {
            if text.isValidPhone() {
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
        if let urlString = urlString?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            if let url = NSURL(string: urlString) {
                UIApplication.shared.open(url as URL)
            }
        }
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
    
    static func genQR(text: String) -> Data? {
        let data = text.data(using: .utf8)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                let data = UIImage(ciImage: output).pngData()
                return data
            }
        }
        return nil
    }
}

extension QRHelper {
    @objc func shareImageInstagram(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            return
        }
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let lastAsset = fetchResult.firstObject {
            let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                let urlStr = "https://itunes.apple.com/in/app/instagram/id389801252?mt=8"
                UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                
            }
        }
    }
    
    func share(image: UIImage, for serviceType: String, from presentingVC: UIViewController) {
        if let composeVC = SLComposeViewController(forServiceType:serviceType) {
            composeVC.add(image)
            presentingVC.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func shareImageViaInstagram(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(shareImageInstagram(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func shareImageViaTwitter(image: UIImage) {
        let instagramURL = URL(string: "twitter://app")
        if UIApplication.shared.canOpenURL(instagramURL!),
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.add(image)
            AppHelper.getRootViewController()?.present(vc, animated: true)
        } else {
            let urlStr = "https://apps.apple.com/us/app/twitter/id333903271"
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
        }
    }
    
    func facebookShare(image: UIImage) {
        var photo: SharePhoto!
        
        photo = SharePhoto(image: image, isUserGenerated: false)
        let content = SharePhotoContent()
        content.photos = [photo]
        let dialog = ShareDialog(viewController: AppHelper.getRootViewController(), content: content, delegate: nil)
        do {
            try dialog.validate()
        } catch {}
        guard let schemaUrl = URL(string: "fb://") else {
            return
        }
        if UIApplication.shared.canOpenURL(schemaUrl) {
        } else {
            let urlStr = "https://apps.apple.com/vn/app/facebook/id284882215"
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
        }
        dialog.show()
    }
}
