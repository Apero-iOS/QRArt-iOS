//
//  File.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 27/06/2023.
//

import Foundation
import StoreKit
import SwiftUI

final class Router {
    
    public static func showTabbar(window: UIWindow? = nil) {
        Router.setRootView(view: TabbarView(), window: window)
    }
    
    public static func showFirstLanguage(window: UIWindow? = nil) {
        let viewModel = LanguageViewModel(sourceOpen: .splash)
        Router.setRootView(view: LanguageView(viewModel: viewModel), window: window)
    }
    
    public static func showOnboarding(window: UIWindow? = nil) {
        Router.setRootView(view: OnboardingView(), window: window)
    }
    
    public static func requestReview() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
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
