//
//  File.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import Foundation
import SwiftUI

final class Router {
    
    public static func showTabbar(window: UIWindow? = nil) {
        Router.setRootView(view: TabbarView(), window: window)
    }
    
    public static func showOnboarding(window: UIWindow? = nil) {
        Router.setRootView(view: OnboardingView(), window: window)
    }
    
    //MARK: private
    private static func setRootView<T: View>(view: T, window: UIWindow? = nil) {
        if window != nil {
            window?.rootViewController = UIHostingController(rootView: view)
            UIView.transition(with: window!,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            return
        }else {
            if let keyWindow = (UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })) {
                keyWindow.rootViewController = UIHostingController(rootView: view)
                UIView.transition(with: keyWindow,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
            }
        }
    }
    
}
