//
//  TooltipsView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 25/07/2023.
//

import SwiftUI

struct TooltipsView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = TooltipsViewModel()
    var isShowAdsBanner: Bool = false
    var type: TooltipType
    var onTapCallback: VoidBlock?
    
    var body: some View {
        ZStack(alignment: type.alignment) {
            ZStack(alignment: type.alignment) {
                Color.black
                    .opacity(0.6)
                
                BackdropBlurView(radius: 4)
                
                highlightView
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.3)) {
                            viewModel.opacity = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onTapCallback?()
                        }
                    }
            }
            .compositingGroup()
            
            guideView
            
            if !type.stepString.isEmpty {
                stepButton
            }
        }
        .ignoresSafeArea()
        .opacity(viewModel.opacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                viewModel.opacity = 1
            }
        }
    }
    
    @ViewBuilder var highlightView: some View {
        switch type {
        case .home:
            HStack {
                Spacer()
                
                Rectangle()
                    .frame(width: WIDTH_SCREEN / 2)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .blendMode(.destinationOut)
            }
            .frame(height: 137)
        case .qrType:
            Rectangle()
                .frame(height: 184)
                .blendMode(.destinationOut)
                .padding(.top, safeAreaInsets.top + 306)
        case .generate:
            Rectangle()
                .frame(height: 88)
                .blendMode(.destinationOut)
                .padding(.bottom, viewModel.getBottomPadding(isShowAdsBanner, safeArea: safeAreaInsets))
        }
    }
    
    @ViewBuilder var guideView: some View {
        switch type {
        case .home:
            VStack {
                Text(Rlocalizable.create_your_ai_qr_code)
                    .font(R.font.digitalStripBB.font(size: 24))
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
                    .multilineTextAlignment(.center)
                
                Image(R.image.tooltip_arrow_down_ic)
            }
            .padding(EdgeInsets(top: 0,
                                leading: 60,
                                bottom: viewModel.getBottomPadding(isShowAdsBanner, safeArea: safeAreaInsets) + 110,
                                trailing: 0))
        case .qrType:
            VStack {
                Text(Rlocalizable.give_input_for_qr)
                    .font(R.font.digitalStripBB.font(size: 24))
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
                    .multilineTextAlignment(.center)
                
                Image(R.image.tooltip_arrow_down_ic)
            }
            .padding(EdgeInsets(top: safeAreaInsets.top + 196,
                                leading: 0,
                                bottom: 0,
                                trailing: 90))
        case .generate:
            VStack {
                Text(Rlocalizable.final_step_initiate_qr_morph)
                    .font(R.font.digitalStripBB.font(size: 24))
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
                    .multilineTextAlignment(.center)
                
                Image(R.image.tooltip_arrow_down_ic)
            }
            .padding(EdgeInsets(top: 0,
                                leading: 0,
                                bottom: viewModel.getBottomPadding(isShowAdsBanner, safeArea: safeAreaInsets) + 80,
                                trailing: 60))
        }
    }
    
    @ViewBuilder var stepButton: some View {
        HStack {
            Spacer()
            
            HStack {
                Text("\(Rlocalizable.next().uppercased()) (\(type.stepString))")
                    .font(R.font.urbanistBold.font(size: 16))
                    .foregroundColor(R.color.color_653AE4.color)
                    .padding(.horizontal, 19)
                    .padding(.vertical, 8)
            }
            .background(.white)
            .border(radius: 20, color: R.color.color_653AE4.color, width: 1)
            .shadow(color: R.color.color_9355D3_40.color, radius: 16, x: 0, y: 0)
        }
        .frame(height: 40)
        .padding(EdgeInsets(top: HEIGHT_SCREEN - safeAreaInsets.bottom - 60,
                            leading: 0,
                            bottom: 0,
                            trailing: 20))
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                viewModel.opacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                onTapCallback?()
            }
        }
    }
}

struct TooltipsView_Previews: PreviewProvider {
    static var previews: some View {
        TooltipsView(isShowAdsBanner: true, type: .home)
    }
}
