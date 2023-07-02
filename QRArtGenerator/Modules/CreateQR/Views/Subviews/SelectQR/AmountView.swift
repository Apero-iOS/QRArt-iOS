//
//  AmountView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 02/07/2023.
//

import SwiftUI

struct AmountView: View {
    @Binding var amount: String
    @Binding var validInput: Bool
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Rlocalizable.amount)
                .font(R.font.urbanistSemiBold.font(size: 14))
                .foregroundColor(R.color.color_1B232E.color)
            TextField(text: $amount) {
                Text("$")
                    .foregroundColor(R.color.color_1B232E.color)
                    .font(R.font.urbanistRegular.font(size: 14))
                    
            }
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            .frame(height: 42)
            .focused($isFocused)
            .border(radius: 12, color: getBorderColor(),
                    width: 1)
            
        }
    }
    func getBorderColor() -> Color {
        if validInput && amount.isEmpty {
            return R.color.color_BD1E1E.color
        } else {
            if isFocused {
                return R.color.color_653AE4.color
            } else {
                return R.color.color_EAEAEA.color
            }
        }
    }
}

struct AmountView_Previews: PreviewProvider {
    static var previews: some View {
        AmountView(amount: .constant("$"), validInput: .constant(false))
    }
}
