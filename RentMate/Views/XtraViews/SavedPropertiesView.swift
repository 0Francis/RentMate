//
//  SavedPropertiesView.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import SwiftUI

struct SavedPropertiesView: View {
    @EnvironmentObject var propertyVM: PropertyViewModel
    @State private var savedProperties: [PropertyModel] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Saved Properties")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if savedProperties.isEmpty {
                    emptySavedView
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(savedProperties) { property in
                            savedPropertyCard(property: property)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Saved Properties")
        .onAppear {
            loadSavedProperties()
        }
    }
    
    private var emptySavedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Saved Properties")
                    .font(.headline)
                Text("Save properties you're interested in to find them easily later.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            Button("Browse Properties") {
                // This would navigate to home tab in a real app
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    private func savedPropertyCard(property: PropertyModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Property Image
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.2))
                .frame(height: 160)
                .overlay(
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        HStack {
                            Text(property.status == "vacant" ? "Available" : "Occupied")
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(property.status == "vacant" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                .foregroundColor(property.status == "vacant" ? .green : .orange)
                                .cornerRadius(6)
                            
                            Spacer()
                            
                            Button(action: {
                                removeFromSaved(property)
                            }) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.title3)
                            }
                        }
                        .padding(.horizontal)
                    }
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(property.title)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(property.address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ksh \(Int(property.rent))")
                            .font(.title3.bold())
                            .foregroundColor(.blue)
                        Text("per month")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if property.status == "vacant" {
                        Button("Apply Now") {
                            // Navigate to application
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(width: 120)
                    } else {
                        Text("Not Available")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func loadSavedProperties() {
        // In real app, load from saved properties list
        // For demo, show some available properties
        savedProperties = propertyVM.properties.prefix(2).map { $0 }
    }
    
    private func removeFromSaved(_ property: PropertyModel) {
        savedProperties.removeAll { $0.id == property.id }
        // In real app, update in persistence layer
    }
}

#Preview {
    NavigationStack {
        SavedPropertiesView()
    }
    .environmentObject(PropertyViewModel())
}