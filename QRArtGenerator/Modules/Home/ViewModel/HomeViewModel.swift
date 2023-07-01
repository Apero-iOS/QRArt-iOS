//
//  HomeViewModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 30/06/2023.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject, Identifiable {
    
    @Published var listStyle: [TemplateModel] = []
    @Published var isActive = false
    
    private var templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetchTemplate()
    }
    
    func fetchTemplate() {
        templateRepository.fetchTemplate().sink { comple in
            switch comple {
            case .finished:
                print("tuanlt: finished")
            case .failure(let error):
                print("tuanlt: \(error)")
            }
        } receiveValue: { [weak self] templates in
            if let templates = templates {
                self?.listStyle = templates
            }
        }.store(in: &cancellable)
    }
}
