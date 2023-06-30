//
//  EdgeInsets+.swift
//  QRArtGenerator
//
//  Created by khac tao on 30/06/2023.
//


import SwiftUI

extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
