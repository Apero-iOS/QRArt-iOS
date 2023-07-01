//
//  AdViewController.swift
//  QRArtGenerator
//
//  Created by khac tao on 01/07/2023.
//

import Foundation
import SwiftUI

protocol AdViewControllerWidthDelegate: AnyObject {
    func adViewController(_ AdViewController: AdViewController, didUpdate width: CGFloat)
}

class AdViewController: UIViewController {
    weak var delegate: AdViewControllerWidthDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Tell the delegate the initial ad width.
        delegate?.adViewController(
            self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
    }
    
    override func viewWillTransition(
        to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
        coordinator.animate { _ in
            // do nothing
        } completion: { _ in
            // Notify the delegate of ad width changes.
            self.delegate?.adViewController(
                self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
        }
    }
}
