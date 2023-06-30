//
//  CreateQRView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct CreateQRView: View {
    @ObservedObject var viewModel = CreateQRViewModel()
    @State var showingSelectQRTypeView: Bool = false
    @State var showingSelectCountryView: Bool = false
    
    var body: some View {
        VStack {
            naviView
            ScrollView {
                LazyVStack {
                    templateView
                    qrDetailView
                    advancedSettingsView
                }
            }
            VStack {
                Button(Rlocalizable.generate_qr()) {
                    
                }
                .frame(maxWidth: WIDTH_SCREEN, maxHeight: 42)
                .clipShape(Capsule())
                .background(R.color.color_653AE4.color)
                .foregroundColor(Color.white)
                .font(R.font.urbanistSemiBold.font(size: 14))
                .cornerRadius(20)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .bottomSheet(isPresented: $showingSelectQRTypeView,
                     height: HEIGHT_SCREEN/2,
                     topBarBackgroundColor: R.color.color_F7F7F7.color,
                     onDismiss: {
            showingSelectQRTypeView = false
        }) {
            qrSelectView
        }
        .bottomSheet(isPresented: $showingSelectCountryView,
                     height: HEIGHT_SCREEN/2,
                     topBarBackgroundColor: R.color.color_F7F7F7.color,
                     onDismiss: {
            showingSelectCountryView = false
        }) {
            countrySelectView
        }
        .hideNavigationBar()
        .onAppear {
            viewModel.fetchCountry()
            viewModel.fetchTemplate()
        }
    }
    
    @ViewBuilder var templateView: some View {
        ChooseTemplateView()
    }
    
    @ViewBuilder var qrDetailView: some View {
        SelectQRDetailView(showingSelectQRTypeView: $showingSelectQRTypeView, showingSelectCountryView: $showingSelectCountryView, type: viewModel.typeQR)
    }
    
    @ViewBuilder var advancedSettingsView: some View {
        AdvancedSettingsView()
    }
    
    @ViewBuilder var qrSelectView: some View {
        SelectQRTypeView(selectedType: $viewModel.typeQR, showingSelectQRTypeView: $showingSelectQRTypeView)
    }
    
    @ViewBuilder var countrySelectView: some View {
        SelectCountryCodeView(countries: $viewModel.countries, selectedCountry: $viewModel.countrySelect)
    }
    
    @ViewBuilder var naviView: some View {
        NavibarView(title: Rlocalizable.create_qr_title(), isImageTitle: true, isRightButton: true) {
            // TODO
        }
    }
    
}

struct CreateQRView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQRView()
    }
}
