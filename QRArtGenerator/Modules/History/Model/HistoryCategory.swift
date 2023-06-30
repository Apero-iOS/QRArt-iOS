//
//  HistoryCategory.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 30/06/2023.
//

import Foundation

struct HistoryCategory: Equatable {
    let type: QRGroupType?
    let count: Int
    
    static func == (lhs: HistoryCategory, rhs: HistoryCategory) -> Bool {
        return lhs.type == rhs.type
    }
}
