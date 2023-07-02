//
//  Loading.swift
//  Base-IOS
//
//  Created by Đinh Văn Trình on 27/06/2022.
//

import UIKit
import PKHUD

class ProgressHUD: NSObject {
    private(set) static var isShowing = false
    
    static func show(view: UIView? = nil)  {
        guard !isShowing else { return }
        isShowing = true
        DispatchQueue.main.async {
            HUD.giftShow(.progress, onView: view)
        }
    }
    
    static func showProgress(view: UIView? = nil, progress: Float)  {
        guard !isShowing else {
            (PKHUD.sharedHUD.contentView as? PKHUDProgressView)?.subtitleLabel.text = String(format: "%d%@", Int(progress*100), "%")
            return
        }
        isShowing = true
        let contentView = PKHUDProgressView(title: "Export", subtitle: String(format: "%d%@", Int(progress*100), "%"))
        contentView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        contentView.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        PKHUD.sharedHUD.contentView = contentView
        PKHUD.sharedHUD.show(onView: view)
    }
    
    static func hideProgress() {
        guard isShowing else { return }
        PKHUD.sharedHUD.hide()
        isShowing = false
    }
    
    static func hide(animated: Bool = true) {
        guard isShowing else { return }
        DispatchQueue.main.async {
            HUD.hide(animated: animated)
        }
        isShowing = false
    }
}

extension HUD {
    public static func giftShow(_ content: HUDContentType, onView view: UIView? = nil) {
        let contentView = PKHUDProgressView(title: "", subtitle: "")
        contentView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        contentView.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        PKHUD.sharedHUD.contentView = contentView
        PKHUD.sharedHUD.show(onView: view)
    }
}
