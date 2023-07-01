//
//  QRItem.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 29/06/2023.
//

import SwiftUI

protocol QRItem {
    var id: String { get }
    var qrImage: UIImage { get }
    var name: String { get }
    var createdDate: Date { get }
    var groupType: QRGroupType { get }
    var type: QRType { get }
}
