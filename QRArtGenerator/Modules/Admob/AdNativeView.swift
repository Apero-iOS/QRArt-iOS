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
import UIKit

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
        adViewController.view.backgroundColor = UIColor(red: 0.933, green: 0.925, blue: 1, alpha: 1)
        nativeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        return adViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

//extension UIColor {
//    convenience init(hex: Int,  alpha: CGFloat = 1.0) {
//        self.init(red: ((hex >> 16) & 0xFF), green: ((hex >> 8) & 0xFF), blue: (hex & 0xFF), alpha: alpha)
//    }
//}
