//
//  AppHelper.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 29/06/2023.
//

import Foundation
import SwiftUI
import NetworkExtension
import MobileAds

struct AppHelper {
    
    public static func getVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static func getRootViewController() -> UIViewController? {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow }))?.rootViewController
    }
    
}

struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}


struct ActivityView: UIViewControllerRepresentable {
    var url: String
    @Binding var showing: Bool

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(
            activityItems: [NSURL(string: url)!],
            applicationActivities: nil
        )
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.showing = false
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

extension AdUnitID {
    static let inter_splash = AdUnitID(rawValue: true ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-4973559944609228/1577128674")
    static let native_language = AdUnitID(rawValue: true ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-4973559944609228/2271279159")
    static let open_app = AdUnitID(rawValue: true ? SampleAdUnitID.adFormatAppOpen : "ca-app-pub-4973559944609228/4134971263")
    static let banner_home = AdUnitID(rawValue: true ? SampleAdUnitID.adFormatBanner : "ca-app-pub-4973559944609228/1508807921")
    static let reward_upload = AdUnitID(rawValue: true ? SampleAdUnitID.adFormatRewarded : "ca-app-pub-4973559944609228/3392789133")
}
