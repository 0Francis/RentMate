//
//  PropertySelectionView.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import SwiftUI

struct PropertySelectionView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    @Binding var hasAssignedProperty: Bool
    @State private var selectedProperty: PropertyModel?
    @State private var showContactLandlord = false
    
    var availableProperties: [PropertyModel] {
        propertyVM.properties.filter { $0.status == "vacant" }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "house.circle.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.blue)
                        
                        Text("Select Your Property")
                            .font(.title.bold())
                        
                        Text("Choose from available properties or contact a landlord")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    if availableProperties.isEmpty {
                        // No available properties
                        EmptyPropertiesView(showContactLandlord: $showContactLandlord)
                    } else {
                        // Available properties list
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Available Properties")
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            LazyVStack(spacing: 16) {
                                ForEach(availableProperties) { property in
                                    PropertySelectionCard(
                                        property: property,
                                        isSelected: selectedProperty?.id == property.id
                                    ) {
                                        selectedProperty = property
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Select Button
                        if let selectedProperty = selectedProperty {
                            Button("Select \(selectedProperty.title)") {
                                assignToProperty(selectedProperty)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                    
                    // Contact Landlord Option
                    Button("Contact a Landlord") {
                        showContactLandlord = true
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Property Selection")
            .sheet(isPresented: $showContactLandlord) {
                ContactLandlordView()
            }
        }
    }
    
    private func assignToProperty(_ property: PropertyModel) {
        // In a real app, this would:
        // 1. Update property status to "occupied"
        // 2. Add tenant ID to property.tenants array
        // 3. Save to backend/database
        
        // For demo, we'll just update locally
        var updatedProperties = propertyVM.properties
        if let index = updatedProperties.firstIndex(where: { $0.id == property.id }) {
            var updatedProperty = updatedProperties[index]
            updatedProperty.status = "occupied"
            // updatedProperty.tenants.append(authVM.currentUser?.id ?? "")
            updatedProperties[index] = updatedProperty
            
            // Save updated properties
            LocalDataService.shared.save(updatedProperties, to: AppConstants.Files.properties)
            propertyVM.properties = updatedProperties
            
            // Mark as having assigned property
            hasAssignedProperty = true
        }
    }
}

struct PropertySelectionCard: View {
    let property: PropertyModel
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 15) {
                // Property Image
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "house.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(property.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(property.address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Text("Ksh \(Int(property.rent))")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("Available")
                            .font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.title2)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyPropertiesView: View {
    @Binding var showContactLandlord: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.lodge")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Available Properties")
                    .font(.headline)
                Text("All properties are currently occupied. Contact a landlord to find available units.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            Button("Contact Landlords") {
                showContactLandlord = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct ContactLandlordView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "envelope.open.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Contact Landlords")
                        .font(.title2.bold())
                    
                    Text("Reach out to landlords directly to inquire about property availability and rental opportunities.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ContactMethodCard(
                            icon: "phone.fill",
                            title: "Call Landlords",
                            description: "Direct phone contact for immediate response",
                            action: { /* Open phone */ }
                        )
                        
                        ContactMethodCard(
                            icon: "message.fill",
                            title: "Send Messages", 
                            description: "Text or WhatsApp for quick inquiries",
                            action: { /* Open messaging */ }
                        )
                        
                        ContactMethodCard(
                            icon: "envelope.fill",
                            title: "Email Inquiries",
                            description: "Formal communication with property details",
                            action: { /* Open email */ }
                        )
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Contact Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ContactMethodCard: View {
    let icon: String
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PropertySelectionView(hasAssignedProperty: .constant(false))
        .environmentObject(AuthViewModel())
        .environmentObject(PropertyViewModel())
}