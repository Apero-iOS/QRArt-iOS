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
    
    @Published var categories: [Category] = []
    @Published var templates: [Template] = AppHelper.templates
    @Published var isShowGenerateQR = false
    @Published var isShowToast = false
    @Published var msgError: String = ""
    
    private var templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetchTemplate()
    }
    
    func fetchTemplate() {
        templateRepository.fetchTemplates().sink { [weak self] comple in
            guard let self = self else { return }
            switch comple {
            case .finished:
                break
            case .failure(let error):
                self.msgError = error.message
                self.isShowToast.toggle()
            }
        } receiveValue: { [weak self] listTemplates in
            guard let self = self else { return }
            self.templates.removeAll()
            if let templates = listTemplates?.items {
                self.templates.append(contentsOf: templates)
                AppHelper.templates = templates
            }
            
        }.store(in: &cancellable)
    }
}
