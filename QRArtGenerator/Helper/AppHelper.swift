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

extension RemoteKey {
    static let inter_generate = RemoteKey(rawValue: "inter_generate")
    static let inter_regenerate = RemoteKey(rawValue: "inter_regenerate")
    static let inter_inspire = RemoteKey(rawValue: "inter_inspire")
    static let inter_change_screen = RemoteKey(rawValue: "inter_change_screen")
    static let native_result = RemoteKey(rawValue: "native_result")
}

extension AdUnitID {
    static let inter_change_screen = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/3730109139")
    static let inter_inspire = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/4061281622")
    static let inter_generate = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/4444425002")
    static let inter_regenerate = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/4188386086")
    static let native_result = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-6530974883137971/6291805244")
    
    static let native_language = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-4973559944609228/2271279159")
    static let open_app = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatAppOpen : "ca-app-pub-4973559944609228/4134971263")
    static let banner_home = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatBanner : "ca-app-pub-4973559944609228/1508807921")
    static let reward_upload = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatRewarded : "ca-app-pub-4973559944609228/3392789133")
}
