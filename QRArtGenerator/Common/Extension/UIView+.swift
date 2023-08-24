//
//  UIView+Extension.swift
//  Base-IOS
//
//  Created by Đinh Văn Trình on 27/06/2022.
//

import UIKit

protocol XibView {
    static var name: String { get }
    static func createFromXib() -> Self
}

extension XibView where Self: UIView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func createFromXib() -> Self {
        return Self.init()
    }
}

extension UIView: XibView { }

extension UIView {
    var name: String {
        return type(of: self).name
    }
    
    class func nib() -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed( name, owner: nil, options: nil)![0] as! T
    }
}

extension UIView {
    func setBorder(width: CGFloat, color: UIColor, radius: CGFloat = 0) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    
    func setBackgroundColor(color: UIColor) {
        self.layer.backgroundColor = color.cgColor
    }
    
    func constraintToAllSides(of container: UIView, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor, constant: topOffset),
            leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: leftOffset),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: rightOffset),
            bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: bottomOffset)
        ])
    }
    
    func hidenView(_ isHidden: Bool,
                   with inView: UIView? = nil,
                   time: TimeInterval = 0.35,
                   completion: (() -> Void)? = nil) {
        UIView.transition(with: inView != nil ? inView! : self,
                          duration: time,
                          options: [UIView.AnimationOptions.transitionCrossDissolve],
                          animations: {
            self.isHidden = isHidden
        },
                          completion: { _ in
            completion?()
        })
    }
}

extension UIView {
    @IBInspectable var mborderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var mborderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var halfRadius: Bool {
        get {
            setNeedsDisplay()
            return layer.cornerRadius == frame.size.height/2
        }
        
        set {
            if newValue {
                clipsToBounds = true
                layer.cornerRadius = frame.size.height/2
                setNeedsDisplay()
            } else {
                layer.cornerRadius = cornorRadius
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var cornorRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            if halfRadius {
                return
            } else {
                layer.cornerRadius = newValue
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
}

extension UIView {
    
    // Hide a view with default animation
    func hide(animation: Bool = true, duration: TimeInterval = 0.3, completion: (() -> ())? = nil) {
        // allway update UI on mainthread
        DispatchQueue.main.async {
            
            if !animation || self.isHidden {
                self.isHidden = true
                completion?()
                return
            }
            
            let currentAlpha = self.alpha
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            }, completion: { (success) in
                self.isHidden = true
                self.alpha = currentAlpha
                completion?()
            })
        }
    }
    
    //Show a view with animation
    func show(animation: Bool = true, duration: TimeInterval = 0.3, completion: (() -> ())? = nil) {
        
        //allway update UI on mainthread
        DispatchQueue.main.async {
            
            if !animation || !self.isHidden {
                self.isHidden = false
                completion?()
                return
            }
            
            let currentAlpha = self.alpha
            self.alpha = 0.05
            self.isHidden = false
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = currentAlpha
            }, completion: { (success) in
                completion?()
            })
        }
    }
    
    func fitParent(padding: UIEdgeInsets = .zero) {
        
        guard let parent = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.leftAnchor.constraint(equalTo: parent.leftAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            self.rightAnchor.constraint(equalTo: parent.rightAnchor)
        ])
    }
    
    //rotate view 3D with Z
    func rotate(duration: CFTimeInterval = 0.8, toValue: Any = Float.pi*2, repeatCount: Float = .infinity, removeOnCompleted: Bool = false) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = duration
        animation.toValue = toValue
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = removeOnCompleted
        layer.add(animation, forKey: "rotate")
    }
    
    // Remove rotate animation
    func stopRotate() {
        layer.removeAnimation(forKey: "rotate")
    }
}

extension UIView {
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

extension UIView {
    var x: CGFloat {
        get {
            self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var height: CGFloat {
        get {
            self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var width: CGFloat {
        get {
            self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
}

extension UIView {
    static var safeArea: UIEdgeInsets {
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top
        let bottomPadding = window?.safeAreaInsets.bottom
        return .init(top: topPadding ?? 0, left: 0, bottom: bottomPadding ?? 0, right: 0)
    }
    
    static var safeAreaTop: CGFloat {
        return safeArea.top
    }
    
    static var safeAreaBottom: CGFloat {
        return safeArea.bottom
    }
    
    enum BorderSide {
        case top
        case bottom
        case left
        case right
    }
    
    func addBorderToSide(_ side: BorderSide, color: UIColor?, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        
        switch side {
            case .top:
                border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
                border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
            case .bottom:
                border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
                border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
                border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            case .right:
                border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
                border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
        }
        
        addSubview(border)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    var isViewEnabled: Bool {
        get {
            return self.isUserInteractionEnabled
        }
        set(value) {
            self.isUserInteractionEnabled = value
            self.alpha = value ? 1 : 0.4
        }
    }
}

extension UIView {
    func addShadow(offset: CGSize = CGSize.zero, color: UIColor = .black, opacity: Float = 0.11, radius: CGFloat = 10.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
