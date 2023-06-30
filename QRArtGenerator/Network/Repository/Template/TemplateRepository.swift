//
//  TemplateRepository.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation
import Combine

protocol TemplateRepositoryProtocol {
    func fetchTemplate(page: Int, limit: Int) -> AnyPublisher<Template?, APIError>
}

class TemplateRepository: BaseAPI<TemplateNetworking>, TemplateRepositoryProtocol {
    func fetchTemplate(page: Int, limit: Int) -> AnyPublisher<Template?, APIError> {
        fetch(target: .fetchTemplate(page: page, limit: limit), responseClass: Template.self)
    }
}
