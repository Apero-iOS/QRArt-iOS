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
    func genQR(data: Data, qrText: String, seed: Int?, positivePrompt: String?, negativePrompt: String?) -> AnyPublisher<Data?, APIError>
}

class TemplateRepository: BaseAPI<TemplateNetworking>, TemplateRepositoryProtocol {
    func fetchTemplate() -> AnyPublisher<[TemplateModel]?, APIError> {
        fetch(target: .fetchTemplate, responseClass: [TemplateModel].self)
    }
    
    func genQR(data: Data, qrText: String, seed: Int?, positivePrompt: String?, negativePrompt: String?) -> AnyPublisher<Data?, APIError> {
        uploadFile(target: .genQR(data: data, qrText: qrText, seed: seed, positivePrompt: positivePrompt, negativePrompt: negativePrompt))
    }
}
