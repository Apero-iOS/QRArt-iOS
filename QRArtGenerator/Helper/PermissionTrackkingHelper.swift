//
//  PermissionTrackkingHelper.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 20/07/2023.
//

import Foundation
import AppTrackingTransparency

class PermissionTrackkingHelper {
    static func requestPermissionTrackking(completion: VoidBlock? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if #available(iOS 14.0, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        // Tracking authorization dialog was shown
                        // and we are authorized
                        print("Authorized")
                        // Now that we are authorized we can get the IDFA
                    case .denied:
                        // Tracking authorization dialog was
                        // shown and permission is denied
                        print("Denied")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                    completion?()
                }
            }
        })
  
    }
}
