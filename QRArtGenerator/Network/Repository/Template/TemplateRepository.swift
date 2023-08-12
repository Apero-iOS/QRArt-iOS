//
//  TemplateRepository.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation
import Combine

protocol TemplateRepositoryProtocol {
    func fetchTemplates() -> AnyPublisher<ListTemplates?, APIError>
    func genQR(qrText: String, positivePrompt: String?, negativePrompt: String?, guidanceScale: Int, numInferenceSteps: Int) -> AnyPublisher<Data?, APIError>
}

class TemplateRepository: BaseAPI<TemplateNetworking>, TemplateRepositoryProtocol {
    func fetchTemplates() -> AnyPublisher<ListTemplates?, APIError> {
        fetch(target: .fetchTemplate, responseClass: ListTemplates.self)
    }
    
    func genQR(qrText: String, positivePrompt: String?, negativePrompt: String?, guidanceScale: Int, numInferenceSteps: Int) -> AnyPublisher<Data?, APIError> {
      
        uploadFile(target: .genQR(qrText: qrText, positivePrompt: positivePrompt, negativePrompt: negativePrompt, guidanceScale: guidanceScale, numInferenceSteps: numInferenceSteps))
    }
}
