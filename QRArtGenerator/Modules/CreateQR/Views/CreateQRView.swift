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
    @StateObject var viewModel: CreateQRViewModel

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
        .bottomSheet(isPresented: $viewModel.showingSelectQRTypeView,
                     height: HEIGHT_SCREEN/2,
                     topBarBackgroundColor: R.color.color_F7F7F7.color,
                     onDismiss: {
            viewModel.showingSelectQRTypeView = false
        }) {
            qrSelectView
        }
        .bottomSheet(isPresented: $viewModel.showingSelectCountryView,
                     height: HEIGHT_SCREEN/2,
                     topBarBackgroundColor: R.color.color_F7F7F7.color,
                     onDismiss: {
            viewModel.showingSelectCountryView = false
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
        ChooseTemplateView(templateQR: $viewModel.templateQR,
                           indexSelectStyle: $viewModel.indexSelectTemplate)
    }
    
    @ViewBuilder var qrDetailView: some View {
        SelectQRDetailView(showingSelectQRTypeView: $viewModel.showingSelectQRTypeView,
                           showingSelectCountryView: $viewModel.showingSelectCountryView,
                           validInput: $viewModel.validInput,
                           input: $viewModel.input,
                           countrySelect: $viewModel.countrySelect,
                           type: viewModel.input.type)
    }
    
    @ViewBuilder var advancedSettingsView: some View {
        if !viewModel.templateQR.isEmpty {
            AdvancedSettingsView(prompt: $viewModel.input.prompt,
                                 negativePrompt: $viewModel.input.negativePrompt,
                                 oldPrompt: $viewModel.templateQR[viewModel.indexSelectTemplate].styles[0].config.positivePrompt,
                                 oldNegativePrompt: $viewModel.templateQR[viewModel.indexSelectTemplate].styles[0].config.negativePrompt)
        }
    }
    
    @ViewBuilder var qrSelectView: some View {
        SelectQRTypeView(selectedType: $viewModel.input.type,
                         showingSelectQRTypeView: $viewModel.showingSelectQRTypeView)
    }
    
    @ViewBuilder var countrySelectView: some View {
        SelectCountryCodeView(countries: $viewModel.countries,
                              selectedCountry: $viewModel.countrySelect,
                              showingSelectCountryView: $viewModel.showingSelectCountryView)
    }
    
    @ViewBuilder var naviView: some View {
        NavibarView(title: Rlocalizable.create_qr_title(), isImageTitle: true, isRightButton: true) {
            // TODO
        }
    }
}

struct CreateQRView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQRView(viewModel: CreateQRViewModel(source: .create, indexSelect: 0, list: []))
    }
}
