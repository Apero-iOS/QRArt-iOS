//
//  SettingRowView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 28/06/2023.
//

import SwiftUI

struct SettingRowView: View {
    
    let item: SettingType
    
    var body: some View {
        HStack {
            item.icon
            Text(item.name)
                .font(R.font.urbanistMedium.font(size: 16))
                .foregroundColor(R.color.color_131318.color)
            Spacer()
            if item == .language {
                Text(LanguageType(rawValue: LocalizationSystem.sharedInstance.getLanguage())?.title ?? "")
                    .font(R.font.urbanistMedium.font(size: 16))
                    .foregroundColor(R.color.color_6A758B.color)
                Image(R.image.ic_arrow_right)
            }
            if item == .version {
                Text(AppHelper.getVersion() ?? "")
                    .font(R.font.urbanistMedium.font(size: 16))
                    .foregroundColor(R.color.color_6A758B.color)
            }
        }
    }
}

struct SettingRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRowView(item: SettingType.language)
    }
}
