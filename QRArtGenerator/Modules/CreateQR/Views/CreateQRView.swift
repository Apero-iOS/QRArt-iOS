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
                Button {
                    viewModel.onTapGenerate()
                } label: {
                    Text(Rlocalizable.generate_qr())
                        .frame(maxWidth: WIDTH_SCREEN, maxHeight: 42)
                        .background(R.color.color_653AE4.color)
                        .foregroundColor(Color.white)
                        .font(R.font.urbanistSemiBold.font(size: 14))
                        .cornerRadius(20)
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: viewModel.isShowAdsBanner ? 0 : 20, trailing: 20))
                
                /// View Ads
                if viewModel.isShowAdsBanner {
                    BannerView(adUnitID: .banner_tab_bar)
                        .frame(height: 50)
                }
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
            viewModel.createIdAds()
        }
        .fullScreenCover(isPresented: $viewModel.isShowLoadingView) {
            LoadingView()
        }
        .fullScreenCover(isPresented: $viewModel.isShowExport) {
            let resultViewModel = ResultViewModel(item: viewModel.input, image: viewModel.imageResult, source: .create)
            ResultView(viewModel: resultViewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showSub) {
            IAPView()
        }
        .onChange(of: viewModel.input.type) { newValue in
            viewModel.input.name = ""
        }
        .toast(message: Rlocalizable.unknow_error(), isShowing: $viewModel.showToastError, position: .center)
    }
    
    @ViewBuilder var templateView: some View {
        ChooseTemplateView(templateQR: $viewModel.templateQR.styles,
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
        if !viewModel.templateQR.styles.isEmpty {
            AdvancedSettingsView(prompt: $viewModel.input.prompt,
                                 negativePrompt: $viewModel.input.negativePrompt,
                                 oldPrompt: $viewModel.templateQR.styles[viewModel.indexSelectTemplate].config.positivePrompt,
                                 oldNegativePrompt: $viewModel.templateQR.styles[viewModel.indexSelectTemplate].config.negativePrompt, guidance: $viewModel.input.guidance,
                                 steps: $viewModel.input.steps,
                                 scale: $viewModel.input.contronetScale,
                                 validInput: $viewModel.validInput)
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
        NavibarView(title: Rlocalizable.create_qr_title(), isImageTitle: true, isRightButton: !UserDefaults.standard.isUserVip, isCloseButton: !viewModel.isPush) {
            viewModel.showSub = true
        }
    }
}
