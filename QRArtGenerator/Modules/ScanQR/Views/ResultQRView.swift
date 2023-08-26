//
//  ResultQRView.swift
//  QRArtGenerator
//
//  Created by khac tao on 29/06/2023.
//

import SwiftUI

struct ResultQRView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Binding var result: ResultQR
    @StateObject var viewModel: ScannerViewModel
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 16) {
                HStack {
                    switch result.type {
                    case .url:
                        Image(R.image.ic_link)
                    case .mail:
                        Image(R.image.ic_email_scanner)
                    case .phone:
                        Image(R.image.ic_phone)
                    case .text:
                        Image(R.image.ic_text_scanner)
                    case .wifi:
                        Image(R.image.ic_wifi_scanner)
                    }
                    HStack {
                        Text(result.title)
                            .font(R.font.beVietnamProMedium.font(size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .truncationMode(.tail)
                            .lineLimit(2)
                    }
                    .background(R.color.color_262930.color)
                    .cornerRadius(12)
                    Button {
                        viewModel.copyText(text: viewModel.qrItem.content)
                    } label: {
                        Image(R.image.ic_copy)
                    }
                    Button {
                        viewModel.isShowShareActivity.toggle()
                    } label: {
                        Image(R.image.ic_result_share)
                    }
                }.frame(height: 44)
                
                HStack {
                    ForEach(result.type.actions, id: \.self) { action in
                        Button {
                            viewModel.handleResult(item: result, actiontype: action)
                        } label: {
                            Text(action.title)
                                .foregroundColor(.white)
                                .font(R.font.beVietnamProMedium.font(size: 14))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(height: 42)
                        .frame(maxWidth: .infinity)
                        .background(R.color.color_653AE4.color)
                        .cornerRadius(21)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea()
        .background(R.color.color_191A1F.color)
    }
    
}

struct ResultQRView_Previews: PreviewProvider {
    @State static var qrResult = ResultQR(type: .phone, content: "Apero", title: "Apero")
    @StateObject static var vm = ScannerViewModel()
    static var previews: some View {
        ResultQRView(result: $qrResult, viewModel: vm)
    }
}
