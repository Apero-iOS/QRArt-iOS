//
//  QRCodeView.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 26/08/2023.
//

import SwiftUI

struct QRCodeView: View {
    
    var image: UIImage
    @Binding var baseUrl: String
    var focusField: FocusState<TextFieldType?>.Binding
    @Binding var validInput: Bool
    var showChoosePhoto: VoidBlock?
    
    var body: some View {
        VStack {
            HStack {
                Text(Rlocalizable.you_qr_code)
                    .foregroundColor(R.color.color_1B232E.color)
                    .font(R.font.beVietnamProSemiBold.font(size: 16))
                Spacer()
              
                Image(R.image.ic_edit.name).frame(width: 24, height: 24).onTapGesture {
                    showChoosePhoto?()
                }
             
            }.padding(.top, 20)
            
            HStack {
                TextEditor(text: $baseUrl)
                    .foregroundColor(R.color.color_6A758B.color)
                    .padding([.top, .leading, .bottom], 12)
                    .focused(focusField, equals: .baseUrl)
                    .frame(maxHeight: 150)
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 76, height: 76)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .cornerRadius(8)
                    .padding(10)
            }
            .border(radius: 12, color: getBorderColor(), width: 1)
            
            if validInput && baseUrl.isEmptyOrWhitespace() {
                textError(text: Rlocalizable.cannot_be_empty())
            }
        }
    }
    
    func textError(text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(R.color.color_BD1E1E.color)
            .font(R.font.beVietnamProRegular.font(size: 14))
    }
    
    func getBorderColor() -> Color {
        if validInput && baseUrl.isEmptyOrWhitespace() {
            return R.color.color_BD1E1E.color
        } else {
            return setColorFocus()
        }
    }
    
    private func setColorFocus() -> Color {
        return focusField.wrappedValue == .baseUrl ? R.color.color_653AE4.color : R.color.color_EAEAEA.color
    }
}

struct QRCodeView_Previews: PreviewProvider {
    @FocusState static var focusState: TextFieldType?
    
    static var previews: some View {
        QRCodeView(image: R.image.frame_banner_home()!, baseUrl: .constant(""), focusField: $focusState, validInput: .constant(true))
    }
}
