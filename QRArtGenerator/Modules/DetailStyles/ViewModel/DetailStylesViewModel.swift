//
//  DetailStylesViewModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 02/07/2023.
//

import Foundation
import SwiftUI

final class DetailStylesViewModel: ObservableObject, Identifiable {
    
    public func getColumns() -> [GridItem] {
        var columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        return columns
    }
    
}
