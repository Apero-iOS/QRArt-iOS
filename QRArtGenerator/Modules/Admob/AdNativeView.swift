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
    var type: NativeAdType
    var blockNativeFaild: VoidBlock? = nil
    
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
                blockNativeFaild?()
            }
        }
        return adViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct AdNativeViewMultiple: UIViewControllerRepresentable {
    
    var nativeView: UIView

    func makeUIViewController(context: Context) -> some UIViewController {
        let adViewController = AdViewController()
        adViewController.view.addSubview(nativeView)
        nativeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        return adViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
