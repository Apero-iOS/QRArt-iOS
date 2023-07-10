//
//  String+.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 10/07/2023.
//

import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
