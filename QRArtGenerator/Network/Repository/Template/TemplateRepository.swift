//
//  TemplateRepository.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation
import Combine

protocol TemplateRepositoryProtocol {
    func fetchTemplate() -> AnyPublisher<[TemplateModel]?, APIError>
}

class TemplateRepository: BaseAPI<TemplateNetworking>, TemplateRepositoryProtocol {
    func fetchTemplate() -> AnyPublisher<[TemplateModel]?, APIError> {
        fetch(target: .fetchTemplate, responseClass: [TemplateModel].self)
    }
}
