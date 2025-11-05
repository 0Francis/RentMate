//
//  ApplicationsTabView.swift
//  RentMate
//
//  Created by Student1 on 04/11/2025.
//


import SwiftUI

struct ApplicationsTabView: View {
    let applications: [RentalApplication]
    @EnvironmentObject var propertyVM: PropertyViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("My Applications")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if applications.isEmpty {
                    emptyApplicationsView
                } else {
                    // Application Stats
                    applicationStatsView
                        .padding(.horizontal)
                    
                    // Applications List
                    LazyVStack(spacing: 12) {
                        ForEach(applications) { application in
                            applicationCard(application: application)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Applications")
        .refreshable {
            // Refresh applications data
        }
    }
    
    private var emptyApplicationsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Applications")
                    .font(.headline)
                Text("You haven't applied to any properties yet. Browse available properties and submit your first application.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    private var applicationStatsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Application Status")
                .font(.headline)
            
            HStack {
                statItem(
                    count: applications.filter { $0.status == "pending" }.count,
                    title: "Pending",
                    color: .orange,
                    icon: "clock.fill"
                )
                
                statItem(
                    count: applications.filter { $0.status == "approved" }.count,
                    title: "Approved", 
                    color: .green,
                    icon: "checkmark.circle.fill"
                )
                
                statItem(
                    count: applications.filter { $0.status == "rejected" }.count,
                    title: "Rejected",
                    color: .red,
                    icon: "xmark.circle.fill"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func statItem(count: Int, title: String, color: Color, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text("\(count)")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func applicationCard(application: RentalApplication) -> some View {
        let property = propertyVM.properties.first { $0.id == application.propertyId }
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(property?.title ?? "Unknown Property")
                        .font(.headline)
                    
                    Text(property?.address ?? "Address not available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Status badge
                Text(application.status.capitalized)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(application.status).opacity(0.2))
                    .foregroundColor(statusColor(application.status))
                    .cornerRadius(8)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Applied: \(application.formattedDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Income: Ksh \(Int(application.monthlyIncome))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Employment: \(application.employmentStatus.capitalized)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if application.isPending {
                    Image(systemName: "clock")
                        .foregroundColor(.orange)
                        .font(.title3)
                } else if application.status == "approved" {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
            
            if let notes = application.notes, !notes.isEmpty {
                Text("Notes: \(notes)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "approved": return .green
        case "rejected": return .red
        case "pending": return .orange
        default: return .gray
        }
    }
}

#Preview {
    NavigationStack {
        ApplicationsTabView(applications: [
            RentalApplication(
                id: "1",
                propertyId: "property-1",
                tenantId: "tenant-1",
                applicationDate: Date().addingTimeInterval(-86400),
                status: "pending",
                tenantName: "John Doe",
                tenantEmail: "john@example.com",
                monthlyIncome: 50000,
                employmentStatus: "employed"
            )
        ])
    }
    .environmentObject(PropertyViewModel())
}