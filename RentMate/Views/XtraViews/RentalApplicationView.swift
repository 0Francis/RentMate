//
//  RentalApplicationView.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import SwiftUI

struct RentalApplicationView: View {
    let property: PropertyModel
    @Binding var isPresented: Bool
    let onApplicationSubmitted: (RentalApplication) -> Void
    
    @EnvironmentObject var authVM: AuthViewModel
    @State private var monthlyIncome = ""
    @State private var employmentStatus = "employed"
    @State private var notes = ""
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Property Summary
                    PropertySummaryCard(property: property)
                        .padding(.horizontal)
                    
                    // Application Form
                    VStack(spacing: 16) {
                        Text("Application Details")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Monthly Income
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Monthly Income")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            TextField("Enter your monthly income", text: $monthlyIncome)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Employment Status
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Employment Status")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Picker("Employment Status", selection: $employmentStatus) {
                                Text("Employed").tag("employed")
                                Text("Self-Employed").tag("self-employed")
                                Text("Student").tag("student")
                                Text("Unemployed").tag("unemployed")
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Additional Notes
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Additional Notes (Optional)")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            TextField("Any additional information for the landlord...", text: $notes, axis: .vertical)
                                .lineLimit(3...6)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Submit Button
                    Button("Submit Application") {
                        submitApplication()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal)
                    .disabled(monthlyIncome.isEmpty)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Apply for \(property.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .alert("Application Submitted", isPresented: $showConfirmation) {
                Button("OK") {
                    isPresented = false
                }
            } message: {
                Text("Your application for \(property.title) has been submitted. The landlord will review it and contact you soon.")
            }
        }
    }
    
    private func submitApplication() {
        guard let income = Double(monthlyIncome) else { return }
        
        let newApplication = RentalApplication(
            id: UUID().uuidString,
            propertyId: property.id,
            tenantId: authVM.currentUser?.id ?? "unknown",
            applicationDate: Date(),
            status: "pending",
            tenantName: authVM.currentUser?.name ?? "Unknown",
            tenantEmail: authVM.currentUser?.email ?? "unknown",
            monthlyIncome: income,
            employmentStatus: employmentStatus,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Save application
        var existingApplications = LocalDataService.shared.load([RentalApplication].self, from: "applications") ?? []
        existingApplications.append(newApplication)
        LocalDataService.shared.save(existingApplications, to: "applications")
        
        // Notify parent
        onApplicationSubmitted(newApplication)
        
        // Show confirmation
        showConfirmation = true
    }
}

struct PropertySummaryCard: View {
    let property: PropertyModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "house.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(property.title)
                        .font(.headline)
                    Text(property.address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Ksh \(Int(property.rent))")
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                    Text("per month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    RentalApplicationView(
        property: PropertyModel(
            id: "1",
            title: "Sample Property",
            address: "123 Main St",
            rent: 15000,
            landlordId: "landlord-1",
            tenants: [],
            status: "vacant"
        ),
        isPresented: .constant(true),
        onApplicationSubmitted: { _ in }
    )
    .environmentObject(AuthViewModel())
}