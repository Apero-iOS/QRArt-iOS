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
    @Namespace var advanceDescViewID
    @FocusState var errorFieldType: TextFieldType?
    @State var change: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                naviView
                ScrollViewReader { proxy in
                    List {
                        templateView
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                            .background(Color.white)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                            .hideSeparatorLine()
                        
                        qrDetailView
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                            .background(Color.white)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                            .hideSeparatorLine()
                        
                        advancedSettingsView(proxy: proxy)
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                            .background(Color.white)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                            .hideSeparatorLine()
                        
                        if viewModel.mode == .expand {
                            advanceDescView
                                .padding(.bottom, 16)
                                .background(Color.white)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .hideSeparatorLine()
                        }
                    }
                    .listStyle(.plain)
                    .background(R.color.color_F7F7F7.color)
                    .clearBackgroundColorList()
                    .hideScrollIndicator()
                }
                
                VStack {
                    Button {
                        viewModel.onTapGenerate()
                        change.toggle()
                        UIApplication.shared.endEditing()
                    } label: {
                        Text(Rlocalizable.generate_qr())
                            .frame(maxWidth: WIDTH_SCREEN, maxHeight: 42)
                            .background(R.color.color_653AE4.color)
                            .foregroundColor(Color.white)
                            .font(R.font.urbanistSemiBold.font(size: 14))
                            .cornerRadius(20)
                    }.padding(EdgeInsets(top: 20, leading: 20, bottom: viewModel.isShowAdsBanner ? 0 : 20, trailing: 20))
                    
                    /// View Ads
                    if viewModel.isShowAdsBanner {
                        BannerView(adUnitID: .banner_tab_bar, fail: {
                            viewModel.isLoadAdsSuccess = false
                        })
                        .hiddenConditionally(isHidden: $viewModel.isLoadAdsSuccess)
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
            UISlider.appearance()
                .setThumbImage(UIImage(named: "ic_tint_slider"), for: .normal)
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
        .onChange(of: change, perform: { _ in
            errorFieldType = viewModel.errorInputType
        })
        .toast(message: viewModel.messageError, isShowing: $viewModel.showToastError, duration: 3, position: .center)
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
                           focusTextfieldType: $errorFieldType,
                           type: viewModel.input.type)
    }
    
    @ViewBuilder func advancedSettingsView(proxy: ScrollViewProxy) -> some View {
        AdvancedSettingsView(mode: $viewModel.mode, rotate: .constant(viewModel.mode == .collapse ? 0 : 90)) { mode in
            switch mode {
            case .expand:
                viewModel.mode = mode
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(advanceDescViewID, anchor: .top)
                    }
                }
            case .collapse:
                withAnimation(.easeIn(duration: 0.2)) {
                    proxy.scrollTo(advanceDescViewID, anchor: .bottom)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    viewModel.mode = mode
                }
            }
        }
        .id(advanceDescViewID)
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
    
    @ViewBuilder var advanceDescView: some View {
        VStack {
            // prompt
            PromptView(oldPrompt: viewModel.templates[viewModel.indexSelectTemplate ?? 0].positivePrompt,
                       title: Rlocalizable.prompt(),
                       subTitle: Rlocalizable.prompt_desc(),
                       typePrompt: .prompt,
                       prompt: $viewModel.input.prompt,
                       validInput: $viewModel.validInput,
                       focusField: $errorFieldType,
                       textfieldType: .prompt)
            // negative prompt
            PromptView(oldPrompt: viewModel.templates[viewModel.indexSelectTemplate ?? 0].negativePrompt,
                       title: Rlocalizable.negative_prompt(),
                       subTitle: Rlocalizable.negative_prompt_desc(),
                       typePrompt: .negativePrompt,
                       prompt: $viewModel.input.negativePrompt,
                       validInput: $viewModel.validInput,
                       focusField: $errorFieldType,
                       textfieldType: .negativePrompt)
            // guidance
            SliderSettingView(title: Rlocalizable.guidance(),
                              desc: Rlocalizable.guidance_desc(),
                              value: $viewModel.input.guidance,
                              fromValue: 1,
                              toValue: 10)

            // steps
            SliderSettingView(title: Rlocalizable.steps(),
                              desc: Rlocalizable.steps_desc(),
                              value: $viewModel.input.steps,
                              fromValue: 1,
                              toValue: 10)
        }
        .padding(.horizontal, 20)
    }
}
