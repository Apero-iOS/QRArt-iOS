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
    
    @Published public var isShowIAP: Bool = false
    @Published public var isVip: Bool = UserDefaults.standard.isUserVip
    
}
