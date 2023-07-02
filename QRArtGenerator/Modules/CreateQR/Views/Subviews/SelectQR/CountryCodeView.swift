//
//  CountryCodeView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import SwiftUI

struct CountryCodeView: View {
    
    var country: Country
    @Binding var selectedCountry: Country
    
    var isSelected: Bool {
        selectedCountry == country
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(R.image.ic_checked)
                .opacity(isSelected ? 1 : 0)
            Text("\(country.name) (\(country.dialCode))")
                .font(R.font.urbanistMedium.font(size: 16))
                .foregroundColor(R.color.color_1B232E.color)
            Spacer()
            AsyncImage(url: country.flagUrl)
                .frame(width: 28, height: 28)
                .cornerRadius(14)
        }
        .frame(maxHeight: 52)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onTapGesture {
            if !isSelected {
                selectedCountry = country
            }
        }
        .background(Color.white)
    }
}

struct CountryCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodeView(country: Country(code: "+93", dialCode: "AF"), selectedCountry: .constant(Country(code: "+93", dialCode: "AF")))
    }
}
