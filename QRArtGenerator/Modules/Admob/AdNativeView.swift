//
//  AdNativeViewController.swift
//  QRArtGenerator
//
//  Created by khac tao on 01/07/2023.
//

import Foundation
import SwiftUI
import MobileAds
import SnapKit

struct AdNativeView: UIViewControllerRepresentable {
    
    private let nativeView = UIView()
    var adUnitID: AdUnitID
    var type: NativeAdType = .small
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let adViewController = AdViewController()
        adViewController.view.addSubview(nativeView)
        nativeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        AdMobManager.shared.addAdNative(unitId: adUnitID, rootVC: adViewController, views: [nativeView], type: type)
        AdMobManager.shared.blockNativeFaild = { id in
            if id == adUnitID.rawValue {
                adViewController.view.isHidden = true
            }
        }
        return adViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
