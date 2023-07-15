//
//  Collection+.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 01/07/2023.
//

import Foundation
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
