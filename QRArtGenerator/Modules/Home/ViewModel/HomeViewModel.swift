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
    @Published var isShowGenerateQR = false
    @Published var isShowToast = false
    @Published var msgError: String = ""
    
    private var templateRepository: TemplateRepositoryProtocol = TemplateRepository()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        fetchTemplate()
    }
    
    func fetchTemplate() {
        templateRepository.fetchTemplate().sink { [weak self] comple in
            switch comple {
            case .finished:
                print("tuanlt: finished")
            case .failure(let error):
                switch error {
                case .No_Network:
                    self?.msgError = Rlocalizable.no_internet()
                default:
                    self?.msgError = Rlocalizable.an_unknown_error()
                }
                self?.isShowToast.toggle()
            }
        } receiveValue: { [weak self] templates in
            if let templates = templates {
                self?.listStyle = templates
            }
        }.store(in: &cancellable)
    }
}
