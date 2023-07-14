//
//  UIApplication+.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 14/07/2023.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
