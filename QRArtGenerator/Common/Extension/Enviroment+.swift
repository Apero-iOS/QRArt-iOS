//
//  Enviroment+.swift
//  QRArtGenerator
//
//  Created by khac tao on 30/06/2023.
//

import SwiftUI

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
