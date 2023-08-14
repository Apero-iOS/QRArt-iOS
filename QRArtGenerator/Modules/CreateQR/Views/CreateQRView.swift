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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            parentView
            .onAppear {
                UISlider.appearance()
                    .setThumbImage(UIImage(named: "ic_tint_slider"), for: .normal)
                viewModel.fetchCountry()
                viewModel.fetchTemplate()
                viewModel.createIdAds()
                FirebaseAnalytics.logEvent(type: .qr_creation_view)
            }
            .fullScreenCover(isPresented: $viewModel.isShowExport) {
                let resultViewModel = ResultViewModel(item: viewModel.input, image: viewModel.imageResult)
                ResultView(viewModel: resultViewModel) { template in
                    viewModel.templateSelect = template
                }
            }
            .fullScreenCover(isPresented: $viewModel.isShowLoadingView) {
                LoadingView { isSub in
                    viewModel.isShowSub = isSub
                }
            }
            .fullScreenCover(isPresented: $viewModel.showSub) {
                IAPView(source: .generateButton)
            }
            .fullScreenCover(isPresented: $viewModel.isShowViewChooseStyle, content: {
                ChooseStyleView(templateSelect: viewModel.templateSelect) { template in
                    viewModel.input.prompt = template.positivePrompt
                    viewModel.input.negativePrompt = template.negativePrompt
                    viewModel.input.templateQRName = template.name
                    viewModel.templateSelect = template
                }
            })
            .bottomSheet(isPresented: $viewModel.isShowPopupCreate, height: 200, topBarCornerRadius: 20, showTopIndicator: false, content: {
                popupGenerateView
            })
            .onChange(of: viewModel.input.type) { newValue in
                viewModel.input.name = ""
            }
            .onChange(of: change, perform: { _ in
                errorFieldType = viewModel.errorInputType
            })
            .toast(message: viewModel.messageError, isShowing: $viewModel.showToastError, duration: 3, position: .center)
    }
    
    @ViewBuilder var parentView: some View {
        if viewModel.isPush {
            contentView
        } else {
            ZStack {
                NavigationView {
                    contentView
                }
                
                if !UserDefaults.standard.tooltipsDone {
                    TooltipsView(type: .qrType) {
                        viewModel.isShowToolTipGenerate = true
                    }
                }
                
                if viewModel.isShowToolTipGenerate {
                    TooltipsView(isShowAdsBanner: viewModel.isShowAdsBanner, type: .generate) {
                        UserDefaults.standard.tooltipsDone = true
                    }
                }
            }
        }
    }
    
    @ViewBuilder var popupGenerateView: some View {
        VStack(spacing: 8) {
            Button {
                viewModel.showAdsInter()
                viewModel.isShowPopupCreate.toggle()
            } label: {
                Text(Rlocalizable.generate_with_an_ad)
                    .foregroundColor(R.color.color_000000.color)
                    .frame(width: UIScreen.screenWidth - 40, height: 50)
                    .background(R.color.color_F7F7F7.color)
                    .border(radius: 100, color: R.color.color_EAEAEA.color, width: 1)
                    .padding(.horizontal, 20)
            }
            
            Button {
                viewModel.showSub = true
                viewModel.isShowPopupCreate.toggle()
            } label: {
                HStack(alignment: .center, spacing: 8) {
                    VStack {
                        Text(Rlocalizable.pro_generate)
                            .foregroundColor(R.color.color_FFFFFF.color)
                            .font(R.font.beVietnamProSemiBold.font(size: 14))
                        Text(Rlocalizable.no_ads_more_quickly)
                            .foregroundColor(R.color.color_FFFFFF.color)
                            .font(R.font.beVietnamProRegular.font(size: 12))
                    }
                    Image(R.image.ic_style_sub.name)
                        .padding(.top, 10)
                }
                .frame(width: UIScreen.screenWidth - 40, height: 50)
                .background(R.color.color_653AE4.color)
                .cornerRadius(100)
                .padding(.horizontal, 20)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder var contentView: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    List {
                        if let qrImage = viewModel.qrImage {
                            VStack {
                                HStack {
                                    Text(Rlocalizable.you_qr_code)
                                        .foregroundColor(R.color.color_1B232E.color)
                                        .font(R.font.beVietnamProSemiBold.font(size: 16))
                                    Spacer()
                                    Image(R.image.ic_edit.name)
                                }
                                HStack {
                                    TextEditor(text: $viewModel.baseUrl)
                                        .foregroundColor(R.color.color_6A758B.color)
                                        .padding([.top, .leading, .bottom], 12)
                                    Image(uiImage: qrImage)
                                        .resizable()
                                        .frame(width: 76, height: 76)
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .cornerRadius(8)
                                        .padding(10)
                                }
                                .border(radius: 12, color: R.color.color_EAEAEA.color, width: 1)
                            }
                        }
                        templateView
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                            .background(Color.white)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .hideSeparatorLine()
                        if viewModel.qrImage == nil {
                            qrDetailView
                                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                                .background(Color.white)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                                .hideSeparatorLine()
                        }
                   
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
                    .clipped()
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
                            .frame(maxWidth: WIDTH_SCREEN, maxHeight: 48)
                            .background(R.color.color_653AE4.color)
                            .foregroundColor(Color.white)
                            .font(R.font.beVietnamProSemiBold.font(size: 14))
                            .cornerRadius(100)
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
           
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        .sheet(isPresented: $viewModel.showingSelectQRTypeView, content: {
            qrSelectView
                .presentationDetent()
        })
        .sheet(isPresented: $viewModel.showingSelectCountryView, content: {
            countrySelectView
                .presentationDetent()
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Rlocalizable.create_qr_title())
        .toolbar {      // navigation bar when create new
            ToolbarItem(placement: .principal) {
                ZStack {
                    HStack {
                        if !viewModel.isPush {
                            Image(R.image.ic_close_screen)
                                .padding(.leading, 4)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text(Rlocalizable.create_qr_title)
                                .font(R.font.urbanistSemiBold.font(size: 18))
                                .lineLimit(1)
                            
                            Image(R.image.ic_shine_ai)
                                .frame(width: 28, height: 24)
                                .offset(x: -3, y: -3)
                        }
                        
                        Spacer()
                        
                        if !UserDefaults.standard.isUserVip {
                            Image(R.image.ic_purchase)
                                .padding(.trailing, 3)
                                .onTapGesture {
                                    viewModel.showSub = true
                                }
                        } else {
                            Color.clear
                                .frame(width: viewModel.isPush ? 33 : 20)
                        }
                    }
                    .frame(height: 48)
                }
               

            }
        }
        .onAppear {
        
        }
    }
    
    @ViewBuilder var templateView: some View {
//        ChooseTemplateView(templates: $viewModel.templates,
//                           indexSelectStyle: $viewModel.indexSelectTemplate)
        VStack {
            HStack {
                Text(Rlocalizable.choose_style)
                    .font(R.font.beVietnamProSemiBold.font(size: 16))
                    .foregroundColor(R.color.color_1B232E.color)
                Spacer()
                Image(R.image.ic_edit.name)
            }.background(Color.white)
            .onTapGesture {
                viewModel.isShowViewChooseStyle.toggle()
            }
            ItemTemplateView(template: $viewModel.templateSelect)
                .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
       
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
    
    @ViewBuilder var advanceDescView: some View {
        // prompt
        PromptView(oldPrompt: viewModel.templateSelect.positivePrompt,
                   title: Rlocalizable.describe_qr_art_idea(),
                   subTitle: Rlocalizable.prompt_desc(),
                   typePrompt: .prompt,
                   prompt: $viewModel.input.prompt,
                   validInput: $viewModel.validInput,
                   focusField: $errorFieldType,
                   textfieldType: .prompt)
        .padding(.horizontal, 20)
        
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                ForEach(0..<10) { index in
                    HStack {
                        Text("Test Tag \(index)")
                            .font(R.font.beVietnamProRegular.font(size: 13))
                            .foregroundColor(R.color.color_6A758B.color)
                            .padding(.horizontal, 11)
                    }
                    .frame(height: 40)
                    .background(R.color.color_EAEAEA.color)
                    .cornerRadius(50)
                }
            }.padding(.horizontal, 20)
        }
        .background(Color.white)
    
    }
}
