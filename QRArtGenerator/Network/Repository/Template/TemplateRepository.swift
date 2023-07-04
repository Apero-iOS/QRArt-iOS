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
    func genQR(data: Data, qrText: String, positivePrompt: String?, negativePrompt: String?, guidanceScale: Int, numInferenceSteps: Int, controlnetConditioningScale: Int) -> AnyPublisher<Data?, APIError>
}

class TemplateRepository: BaseAPI<TemplateNetworking>, TemplateRepositoryProtocol {
    func fetchTemplate() -> AnyPublisher<[TemplateModel]?, APIError> {
        fetch(target: .fetchTemplate, responseClass: [TemplateModel].self)
    }
    
    func genQR(data: Data, qrText: String, positivePrompt: String?, negativePrompt: String?, guidanceScale: Int, numInferenceSteps: Int, controlnetConditioningScale: Int) -> AnyPublisher<Data?, APIError> {
        uploadFile(target: .genQR(data: data, qrText: qrText, positivePrompt: positivePrompt, negativePrompt: negativePrompt, guidanceScale: guidanceScale, numInferenceSteps: numInferenceSteps, controlnetConditioningScale: controlnetConditioningScale))
    }
}
