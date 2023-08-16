//
//  UIImage+.swift
//  QRArtGenerator
//
//  Created by khac tao on 15/08/2023.
//

import Foundation
import UIKit

extension UIImage {
    func resize(_ size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return temp
    }
}
