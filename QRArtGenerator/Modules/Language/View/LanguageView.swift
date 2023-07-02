//
//  LanguageView.swift
//  QRArtGenerator
//
//  Created by Đinh Văn Trình on 29/06/2023.
//

import SwiftUI

struct LanguageView: View {
    @StateObject var viewModel: LanguageViewModel
    
    var body: some View {
        VStack {
            NavibarView(title: Rlocalizable.languages(), isRightButton: true) {
                viewModel.changeLanguageApp()
            }
            List {
                ForEach(0..<viewModel.languages.count, id: \.self) { index in
                    let language = viewModel.languages[index]
                    languageView(language, isSelected: viewModel.selectedIndex == index)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 23, bottom: 0, trailing: 23))
                        .onTapGesture {
                            viewModel.selectedIndex = index
                        }
                }
            }
            .listStyle(.plain)
            .clearBackgroundColorList()
        }
        .hideNavigationBar(isHidden: true)
    }
    
    private func languageView(_ language: LanguageType, isSelected: Bool) -> some View {
        HStack {
            language.icon
                .frame(width: 28, height: 28)
            Text(language.title)
                .font(R.font.urbanistMedium.font(size: 17))
                .foregroundColor(R.color.color_1B232E.color)
            Spacer()
            Image(!isSelected ? R.image.ic_unselect : R.image.ic_selected)
                .frame(width: 24, height: 24)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(Color(R.color.color_EAEAEA), lineWidth: 1)
        )
    }
}

struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView(viewModel: LanguageViewModel(sourceOpen: .setting))
    }
}
