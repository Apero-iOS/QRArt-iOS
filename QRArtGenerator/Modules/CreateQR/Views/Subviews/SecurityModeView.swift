//
//  SecurityModeView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 28/06/2023.
//

import SwiftUI

struct SecurityModeView: View {
    var title: String = "Security Mode"
    var placeholder: String = "Input your Name"
    @State var name: String = ""
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(R.color.color_1B232E.color)
                .font(R.font.urbanistMedium.font(size: 14))
            Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                textDesc(text: "WEP").tag(1)
                textDesc(text: "WPA").tag(2)
                textDesc(text: "WPA2").tag(3)
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder func textDesc(text: String) -> some View {
        Text(text)
            .font(R.font.urbanistSemiBold.font(size: 12))
            .foregroundColor(Color.black)
    }
}

struct SecurityModeView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityModeView()
    }
}
