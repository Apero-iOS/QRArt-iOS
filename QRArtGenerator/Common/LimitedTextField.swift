//
//  LimitedTextField.swift
//  QRArtGenerator
//
//  Created by ANH VU on 10/07/2023.
//

import SwiftUI

struct LimitedTextField: View {
    @State private var enteredString: String = ""
    @Binding var underlyingString: String
    var placeholder: String
    let charLimit : Int
    
    init(placeholder: String, value: Binding<String>, charLimit: Int) {
        _underlyingString = value
        self.charLimit = charLimit
        self.placeholder = placeholder
    }
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $enteredString, onCommit: updateUnderlyingValue)
                .onAppear(perform: { updateEnteredString(newUnderlyingString: underlyingString) })
                .onChange(of: enteredString, perform: updateUndelyingString)
                .onChange(of: underlyingString, perform: updateEnteredString)
        }
    }
    
    func updateEnteredString(newUnderlyingString: String) {
        enteredString = String(newUnderlyingString.prefix(charLimit))
    }
    
    func updateUndelyingString(newEnteredString: String) {
        self.enteredString = String(newEnteredString.prefix(charLimit))
        underlyingString = self.enteredString
    }
    
    func updateUnderlyingValue() {
        underlyingString = enteredString
    }
}
