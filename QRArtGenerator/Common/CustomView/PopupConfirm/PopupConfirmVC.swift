//
//  PopupConfirmVC.swift
//  Base-IOS
//
//  Created by Đinh Văn Trình on 27/06/2022.
//

import UIKit
import Lottie

enum PopupStyle {
    case permission(title: String, message: String, cancel: VoidBlock? = nil, ok: VoidBlock? = nil)
    case confirm(title: String, attributedMessage: NSAttributedString, cancel: VoidBlock? = nil, ok: VoidBlock? = nil)
    case normal
}

class PopupConfirmVC: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    private let minTranform: CGFloat = 0.4
    
    private var titleStr: String?
    private var icon: UIImage?
    private var message: String?
    private var attributedMessage: NSAttributedString?
    private var cancelAction: VoidBlock?
    private var okAction: VoidBlock?
    private var style: PopupStyle = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // start state for animation
        self.view.alpha = 0.0
        self.containerView.transform = CGAffineTransform(scaleX: minTranform, y: minTranform)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationShow()
        lottieView.play()
    }
    
    convenience init(style: PopupStyle) {
        self.init(nib: R.nib.popupConfirmVC)
        self.style = style
        switch style {
            case .permission(title: let title, message: let message, cancel: let cancel, ok: let ok):
                self.titleStr = title
                self.message = message
                self.cancelAction = cancel
                self.okAction = ok
            case .confirm(title: let title, attributedMessage: let attributedMessage, cancel: let cancel, ok: let ok):
                self.titleStr = title
                self.attributedMessage = attributedMessage
                self.cancelAction = cancel
                self.okAction = ok
            case .normal:
                break
        }
    }
    
    // MARK: - Functions
    private func setup() {
        lblTitle.text = titleStr
        if let attributed = attributedMessage {
            lblMessage.attributedText = attributed
        } else {
            lblMessage.text = message
        }
        btnOk.setTitle(Rlocalizable.allow_access(), for: .normal)
        btnCancel.setTitle(Rlocalizable.not_allow(), for: .normal)
    }
    
    // MARK: - Actions
    @IBAction private func tapCancel() {
        animationDismiss {[weak self] in
            self?.cancelAction?()
        }
    }
    
    @IBAction private func tapOK() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: { [weak self] _ in
            self?.okAction?()
        })
    }
    
}

extension PopupConfirmVC {
    private func animationShow() {
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    private func animationDismiss(completion: @escaping VoidBlock) {
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: self.minTranform, y: self.minTranform)
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
        
    }
}

extension UIViewController {
    func presentAlert(_ alert: PopupConfirmVC) {
        DispatchQueue.main.async {
            alert.modalPresentationStyle = .overFullScreen
            self.present(alert, animated: false, completion: nil)
        }
    }
}
