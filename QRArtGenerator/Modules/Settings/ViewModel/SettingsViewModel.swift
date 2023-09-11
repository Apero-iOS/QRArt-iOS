//
//  SettingsViewModel.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 28/06/2023.
//

import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    public let settings = SettingType.allCases
    var cancellable = Set<AnyCancellable>()
    
    deinit {
        cancellable.forEach({$0.cancel()})
    }
    
    @Published public var isShowIAP: Bool = false
    @Published public var activeScreen: SettingType?
    @Published public var isVip: Bool = UserDefaults.standard.isUserVip
    
}
