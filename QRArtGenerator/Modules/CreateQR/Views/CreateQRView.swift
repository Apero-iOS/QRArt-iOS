//
//  CreateQRView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

enum CreateQRViewSource {
    case create
    case template
    case regenerate
}

struct CreateQRView: View {
    @StateObject var viewModel = CreateQRViewModel()
    @State var showingSelectQRTypeView: Bool = false
    @State var showingSelectCountryView: Bool = false
    
    init(source: CreateQRViewSource, indexSelect: Int?, list: [TemplateModel]) {
        viewModel.source = source
        viewModel.indexSelectQR = indexSelect ?? 0
        viewModel.templateQR = list
    }
    
    var body: some View {
        VStack {
            naviView
            ScrollView {
                VStack {
                    templateView
                    qrDetailView
                    advancedSettingsView
                }
            }
            VStack {
                Button(Rlocalizable.generate_qr()) {
                    viewModel.genQR()
                }
                .frame(maxWidth: WIDTH_SCREEN, maxHeight: 42)
                
                .clipShape(Capsule())
                .background(R.color.color_653AE4.color)
                .foregroundColor(Color.white)
                .font(R.font.urbanistSemiBold.font(size: 14))
                .cornerRadius(20)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
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
        .hideNavigationBar(isHidden: true)
        .onAppear {
            viewModel.fetchCountry()
            viewModel.fetchTemplate()
        }
    }
    
    @ViewBuilder var templateView: some View {
        ChooseTemplateView(templateQR: $viewModel.templateQR, indexSelectStyle: $viewModel.indexSelectQR)
    }
    
    @ViewBuilder var qrDetailView: some View {
        SelectQRDetailView(showingSelectQRTypeView: $showingSelectQRTypeView,
                           showingSelectCountryView: $showingSelectCountryView,
                           validInput: $viewModel.validInput,
                           input: $viewModel.input,
                           countrySelect: $viewModel.countrySelect,
                           type: viewModel.input.type)
    }
    
    @ViewBuilder var advancedSettingsView: some View {
        if !viewModel.templateQR.isEmpty {
            AdvancedSettingsView(negativePromt: $viewModel.negativePromt,
                                 positivePrompt: $viewModel.positivePromt,
                                 oldNegativePromt: $viewModel.templateQR[viewModel.indexSelectQR].styles[0].config.negativePrompt,
                                 oldPositivePrompt: $viewModel.templateQR[viewModel.indexSelectQR].styles[0].config.positivePrompt)
        }
    }
    
    @ViewBuilder var qrSelectView: some View {
        SelectQRTypeView(selectedType: $viewModel.input.type, showingSelectQRTypeView: $showingSelectQRTypeView)
    }
    
    @ViewBuilder var countrySelectView: some View {
        SelectCountryCodeView(countries: $viewModel.countries, selectedCountry: $viewModel.countrySelect, showingSelectCountryView: $showingSelectCountryView)
    }
    
    @ViewBuilder var naviView: some View {
        NavibarView(title: Rlocalizable.create_qr_title(), isImageTitle: true, isRightButton: true) {
            // TODO
        }
    }
    
}

struct CreateQRView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQRView(source: .create, indexSelect: 0, list: [])
    }
}
