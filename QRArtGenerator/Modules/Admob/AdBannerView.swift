//
//  AdmobBannerView.swift
//  QRArtGenerator
//
//  Created by khac tao on 01/07/2023.
//

import Foundation
import SwiftUI
import MobileAds
import SnapKit

struct BannerView: UIViewControllerRepresentable {
    
    private let bannerView = UIView()
    var adUnitID: AdUnitID
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let adViewController = AdViewController()
        adViewController.view.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        AdMobManager.shared.addAdBannerAdaptive(unitId: adUnitID, rootVC: adViewController, view: bannerView)
        return adViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
    
    

