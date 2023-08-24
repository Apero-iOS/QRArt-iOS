//
//  TemplateModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

enum TemplateType: Codable {
    case basic
    case normal
}

struct ListTemplates: Codable {
    var items: [Template] = []
    let totalItems, page, limit, totalPages: Int
    let paging: Bool
}

struct Template: Codable, Hashable {
    var category: String = ""
    var name: String = ""
    var positivePrompt: String = ""
    var negativePrompt: String?
    var packageType: String = ""
    var key: String = ""
}

struct Category: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String = ""
    var templates: [Template] = []
}
