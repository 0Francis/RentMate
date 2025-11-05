//
//  PropertyDetailView.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import SwiftUI

struct PropertyDetailView: View {
    let property: PropertyModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(property.title).font(.title.bold())
            Text(property.address).foregroundColor(.secondary)
            Text("Rent: Ksh \(Int(property.rent))").font(.headline)
            Text("Status: \(property.status.capitalized)").font(.subheadline)
            Spacer()
        }
        .padding()
        .navigationTitle("Property")
    }
}
