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
    @Binding var showingSelectCountryView: Bool
    @State var search: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                Spacer()
                Text(Rlocalizable.select_country_code())
                    .font(R.font.urbanistSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                    .frame(maxWidth: WIDTH_SCREEN, maxHeight: 29, alignment: .center)
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        showingSelectCountryView = false
                        search = ""
                        UIApplication.shared.endEditing()
                    } label: {
                        Text(Rlocalizable.done)
                            .font(R.font.urbanistMedium.font(size: 14))
                            .foregroundColor(R.color.color_007AFF.color)
                    }
                }
                .padding(.trailing, 16)
            }
            .frame(maxHeight: 29)
            
            VStack(spacing: 12) {
                // search bar
                HStack(spacing: 8) {
                    R.image.ic_search.image
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 0))
                    TextField(Rlocalizable.search_country(), text: $search)
                        .padding(EdgeInsets(top: 11, leading: 0, bottom: 11, trailing: 0))
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                .frame(height: 40)
                
                // list country
                List {
                    ForEach(listCountry(), id: \.self) { item in
                        CountryCodeView(country: item, selectedCountry: $selectedCountry)
                            .listRowInsets(EdgeInsets())
                            .hideSeparatorLine()
                    }
                }
                .listStyle(.insetGrouped)
                .clearBackgroundColorList()
            }
        }
        .background(R.color.color_F7F7F7.color)
    }
    
    func listCountry() -> [Country] {
        if search.isEmpty {
            return countries
        } else {
            return countries.filter({ $0.name.uppercased().contains(search.uppercased())})
        }
    }
}

struct SelectCountryCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountryCodeView(countries: .constant([]), selectedCountry: .constant(Country(code: "", dialCode: "")), showingSelectCountryView: .constant(true))
    }
}
