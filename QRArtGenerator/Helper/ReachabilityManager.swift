//
//  ReachabilityManager.swift
//  BaseVIPER
//
//  Created by Quang Ly Hoang on 10/07/2022.
//

import Alamofire
import UIKit
import Toast_Swift

class ReachabilityManager {
    class func isNetworkConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    static func startListeningNetworkConnection(connectedHandler: (() -> Void)?, disconnectedHandler: (() -> Void)?) {
        var isConnected = isNetworkConnected()
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { _ in
            guard isConnected != isNetworkConnected() else { return }
            isConnected = isNetworkConnected()
            if isConnected {
                connectedHandler?()
            } else {
                disconnectedHandler?()
            }
        })
    }

    static func stopListeningNetworkConnection() {
        NetworkReachabilityManager.default?.stopListening()
    }
}

//struct Toast {
//    static func showToast(_ message: String, on view: UIView? = UIViewController.top()?.view, point: CGPoint? = nil) {
//        view?.hideToast()
//        let duration: Double = 3.0
//        var toastStyle = ToastStyle()
//        toastStyle.messageAlignment = .center
//        toastStyle.messageFont = R.font.outfitRegular(size: 13)!
//        if let point = point {
//            view?.makeToast(message, duration: duration, point: point, title: nil, image: nil, style: toastStyle, completion: nil)
//        } else {
//            view?.makeToast(message, duration: duration, position: .center, style: toastStyle)
//        }
//    }
//}
