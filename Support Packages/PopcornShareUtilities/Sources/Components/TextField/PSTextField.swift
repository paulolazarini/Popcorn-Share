//
//  PSTextField.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 22/01/25.
//

import SwiftUI

public struct PSTextField: View {
    let placeholder: String
    @Binding var text: String
    
    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(AuthTextFieldStyle())
    }
}
