//
//  TemplateModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

struct TemplateModel: Codable, Identifiable {
    let id: String
    let styles: [Style]
    let category: Category

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case styles, category
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
}

struct Style: Codable, Identifiable {
    let id: String
    let project: String
    let name: String
    let key: String
    let category: String
    let prompt: String
    let config: Config
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
    let negativePrompt: String
    let positivePrompt: String
}

