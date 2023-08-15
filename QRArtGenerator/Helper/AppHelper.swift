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
    
    static func findTextField(in view: UIView?) -> UITextField? {
        if let textField = view as? UITextField {
            return textField
        }
        for subview in view?.subviews ?? [] {
            if let textField = findTextField(in: subview) {
                return textField
            }
        }
        return nil
    }
    
    static var templates: [Template] = []
    
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
        var activityItems: [Any] = []
        if let url = URL(string: url) {
            activityItems = [url]
        } else {
            activityItems = [url]
        }
        let vc = UIActivityViewController(
            activityItems: activityItems,
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
    static let inter_regenerate = RemoteKey(rawValue: "inter_regenerate")
    static let inter_inspire = RemoteKey(rawValue: "inter_inspire")
    static let inter_change_screen = RemoteKey(rawValue: "inter_change_screen")
    static let native_result = RemoteKey(rawValue: "native_result")
    static let app_open_splash = RemoteKey(rawValue: "app_open_splash")
    static let banner_tab_bar = RemoteKey(rawValue: "banner_tab_bar")
    static let languageFirstOpen = RemoteKey(rawValue: "language_first_open")

}

extension AdUnitID {
    static let inter_change_screen = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/3730109139")
    static let inter_inspire = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/4061281622")
    static let inter_generate = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/4444425002")
    static let inter_regenerate = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/4188386086")
    static let native_result = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-6530974883137971/6291805244")
    static let app_open_high_floor = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatAppOpen : "ca-app-pub-6530974883137971/6973421391")
    static let app_open_all_price = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatAppOpen : "ca-app-pub-6530974883137971/1721094710")
    static let banner_tab_bar = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatBanner : "ca-app-pub-6530974883137971/7922189910")
    
    static let open_splash = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatAppOpen : "ca-app-pub-6530974883137971/7922189910")
    static let native_home = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-6530974883137971/7922189910")
    static let inter_template = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/7922189910")
    static let banner_result = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatBanner : "ca-app-pub-6530974883137971/7922189910")
    static let inter_generator = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/7922189910")
    static let native_resultback = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatNativeAdvanced : "ca-app-pub-6530974883137971/7922189910")
    static let reward_regen = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatRewarded : "ca-app-pub-6530974883137971/7922189910")
    static let inter_createmore = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/7922189910")
    static let inter_scanopenlink = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/7922189910")
    static let inter_openmail = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatInterstitial : "ca-app-pub-6530974883137971/7922189910")
    static let banner_scan = AdUnitID(rawValue: Constants.isDev ? SampleAdUnitID.adFormatBanner : "ca-app-pub-6530974883137971/7922189910")
    
    
}
