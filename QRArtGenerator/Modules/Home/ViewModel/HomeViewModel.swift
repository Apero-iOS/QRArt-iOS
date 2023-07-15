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
                switch error {
                case .No_Network:
                    self.msgError = Rlocalizable.no_internet()
                default:
                    self.msgError = Rlocalizable.an_unknown_error()
                }
                self.isShowToast.toggle()
            }
        } receiveValue: { [weak self] listTemplates in
            guard let self = self else { return }
            self.categories.removeAll()
            if let templates = listTemplates?.items {
                Dictionary(grouping: templates, by: { $0.category }).forEach { key, value in
                    self.categories.append(Category(name: key, templates: value))
                }
                self.categories.sort(by: {$0.name < $1.name})
            }
        }.store(in: &cancellable)
    }
}
