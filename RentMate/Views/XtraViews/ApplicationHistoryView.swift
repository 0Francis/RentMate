import SwiftUI

struct ApplicationHistoryView: View {
    let applications: [RentalApplication]
    @Binding var isPresented: Bool
    @EnvironmentObject var propertyVM: PropertyViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Check if this view is being used as a sheet
    private var isSheet: Bool {
        // If isPresented binding is not the default constant, it's being used as a sheet
        return isPresented != false
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if applications.isEmpty {
                        EmptyApplicationsView()
                    } else {
                        // Application Stats
                        applicationStatsView
                            .padding(.horizontal)
                        
                        // Applications List
                        LazyVStack(spacing: 12) {
                            ForEach(applications) { application in
                                ApplicationHistoryCard(application: application)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Application History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isSheet {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
    
    private var applicationStatsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Application Summary")
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
}

struct ApplicationHistoryCard: View {
    let application: RentalApplication
    @EnvironmentObject var propertyVM: PropertyViewModel
    
    var property: PropertyModel? {
        propertyVM.properties.first { $0.id == application.propertyId }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
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
                
                statusIcon
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
    
    private var statusColor: Color {
        switch application.status.lowercased() {
        case "approved": return .green
        case "rejected": return .red
        case "pending": return .orange
        default: return .gray
        }
    }
    
    private var statusIcon: some View {
        Group {
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
    }
}

struct EmptyApplicationsView: View {
    var body: some View {
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
}

#Preview("As Sheet") {
    ApplicationHistoryView(
        applications: [
            RentalApplication(
                id: "1",
                propertyId: "property-1",
                tenantId: "tenant-1",
                applicationDate: Date().addingTimeInterval(-86400),
                status: "pending",
                tenantName: "John Doe",
                tenantEmail: "john@example.com",
                monthlyIncome: 50000,
                employmentStatus: "employed",
                notes: "Looking to move in next month"
            ),
            RentalApplication(
                id: "2",
                propertyId: "property-2",
                tenantId: "tenant-1",
                applicationDate: Date().addingTimeInterval(-172800),
                status: "approved",
                tenantName: "John Doe",
                tenantEmail: "john@example.com",
                monthlyIncome: 45000,
                employmentStatus: "self-employed"
            )
        ],
        isPresented: .constant(true)
    )
    .environmentObject(PropertyViewModel())
}

#Preview("As Standalone") {
    ApplicationHistoryView(
        applications: [
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
        ],
        isPresented: .constant(false)
    )
    .environmentObject(PropertyViewModel())
}
