//
//  AppTextField.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import SwiftUI

struct AppTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .autocapitalization(.none)
    }
}
