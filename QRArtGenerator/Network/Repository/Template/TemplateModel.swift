//
//  TemplateModel.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation

struct Template: Codable {
    let items: [TemplateModel]
}

struct TemplateModel: Codable {
    let id, project, name: String
    let key: String
    let prompt: String
    let config: Config
    let version, createdAt, updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case project, name, key, prompt, config, version, createdAt, updatedAt
        case v = "__v"
    }
}

struct Config: Codable {
    let negativePrompt, positivePrompt: String
}
