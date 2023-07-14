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
        ZStack {
            VStack {
                naviView
                ScrollView {
                    VStack {
                        templateView
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 10, trailing: 0))
                            .background(Color.white)
                        qrDetailView
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 10, trailing: 0))
                            .background(Color.white)
                            
                        advancedSettingsView
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                            .background(Color.white)
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                .background(R.color.color_F7F7F7.color)
                VStack {
                    Button {
                        viewModel.onTapGenerate()
                        UIApplication.shared.endEditing()
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
            if viewModel.isShowLoadingView {
                LoadingView()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .bottomSheet(isPresented: $viewModel.showingSelectQRTypeView,
                     height: HEIGHT_SCREEN,
                     topBarBackgroundColor: R.color.color_F7F7F7.color,
                     onDismiss: {
            viewModel.showingSelectQRTypeView = false
        }) {
            qrSelectView
        }
        .bottomSheet(isPresented: $viewModel.showingSelectCountryView,
                     height: HEIGHT_SCREEN,
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
        ChooseTemplateView(templates: $viewModel.templates,
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
            AdvancedSettingsView(mode: $viewModel.mode,
                                 prompt: $viewModel.input.prompt,
                                 negativePrompt: $viewModel.input.negativePrompt,
                                 oldPrompt: $viewModel.templates[viewModel.indexSelectTemplate].positivePrompt,
                                 oldNegativePrompt: $viewModel.templates[viewModel.indexSelectTemplate].negativePrompt,
                                 guidance: $viewModel.input.guidance,
                                 steps: $viewModel.input.steps,
                                 scale: $viewModel.input.contronetScale,
                                 validInput: $viewModel.validInput)
    }
    
    @ViewBuilder var qrSelectView: some View {
        SelectQRTypeView(selectedType: $viewModel.input.type,
                         showingSelectQRTypeView: $viewModel.showingSelectQRTypeView, groupType: $viewModel.input.groupType)
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
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
