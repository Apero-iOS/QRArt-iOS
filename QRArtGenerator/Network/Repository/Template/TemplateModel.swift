//
//  TemplateModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

enum TemplateType {
    case basic
    case normal
}

struct TemplateModel: Codable, Identifiable {
    let id: String
    var styles: [Style]
    let category: Category

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case styles, category
    }
    
    static func defaultObject() -> TemplateModel {
        TemplateModel(id: "", styles: [], category: Category.defaultObject())
    }
}

struct Category: Codable {
    let id: String
    let project, name, createdAt, updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case project, name, createdAt, updatedAt
        case v = "__v"
    }
    
    static func defaultObject() -> Category {
        Category(id: "", project: "", name: "", createdAt: "", updatedAt: "", v: 0)
    }
}

struct Style: Codable, Identifiable {
    let id: String
    let project: String
    let name: String
    let key: String
    let category: String
    let prompt: String
    var config: Config
    let version: String
    let createdAt, updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case project, name, key, category, prompt, config, version, createdAt, updatedAt
        case v = "__v"
    }
}

struct Config: Codable {
    var negativePrompt: String
    var positivePrompt: String
}

