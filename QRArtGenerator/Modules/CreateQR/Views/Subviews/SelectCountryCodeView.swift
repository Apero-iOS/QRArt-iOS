//
//  SelectCountryCodeView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import SwiftUI

struct SelectCountryCodeView: View {
    @Binding var countries: [Country]
    @Binding var selectedCountry: Country
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                Spacer()
                Text("Select country code")
                    .font(R.font.urbanistSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                    .frame(maxWidth: WIDTH_SCREEN, maxHeight: 29, alignment: .center)
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        
                    } label: {
                        Text(Rlocalizable.done)
                            .font(R.font.urbanistMedium.font(size: 14))
                            .foregroundColor(R.color.color_007AFF.color)
                    }
                }
                .padding(.trailing, 16)
            }
            .frame(maxHeight: 29)
            List {
                ForEach(countries, id: \.self) { item in
                    CountryCodeView(country: item, selectedCountry: $selectedCountry)
                }
            }
            .listStyle(.insetGrouped)
            .clearBackgroundColorList()
        }
        .background(R.color.color_F7F7F7.color)
    }
}

struct SelectCountryCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountryCodeView(countries: .constant([]), selectedCountry: .constant(Country(code: "", dialCode: "")))
    }
}
