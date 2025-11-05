//
//  AppButtonStyle.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import SwiftUI

struct AppButtonStyle: ButtonStyle {
    var isPrimary = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(isPrimary ? Color.blue : Color.white)
            .foregroundColor(isPrimary ? .white : .blue)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
