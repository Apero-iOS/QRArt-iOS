//
//  CreateQRView.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import SwiftUI

struct CreateQRView: View {
    var body: some View {
        NavigationView {
            VStack {
                ChooseTemplateView()
                SelectQRDetailView()
            }
            
            
            
        }
        .navigationTitle("OK")
        .font(.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreateQRView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQRView()
    }
}
