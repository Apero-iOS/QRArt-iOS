//
//  URL+.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 01/07/2023.
//

import Foundation

extension URL {
    var pathString: String {
        if #available(iOS 16.0, *) {
            return path()
        } else {
            return path
        }
    }
}
