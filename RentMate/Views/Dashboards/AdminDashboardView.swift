import SwiftUI
import CoreLocation

struct AdminDashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    @State private var totalUsers: Int = 0
    @State private var totalProperties: Int = 0
    @State private var vacantCount: Int = 0
    @State private var selectedTimeFrame = "Today"

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Admin Dashboard")
                        .font(.largeTitle.bold())
                    Text("Manage your rental platform")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Time Frame Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        TimeFrameButton(title: "Today", isSelected: selectedTimeFrame == "Today") {
                            selectedTimeFrame = "Today"
                        }
                        TimeFrameButton(title: "Week", isSelected: selectedTimeFrame == "Week") {
                            selectedTimeFrame = "Week"
                        }
                        TimeFrameButton(title: "Month", isSelected: selectedTimeFrame == "Month") {
                            selectedTimeFrame = "Month"
                        }
                        TimeFrameButton(title: "All Time", isSelected: selectedTimeFrame == "All Time") {
                            selectedTimeFrame = "All Time"
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Stats Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    AdminStatCard(title: "Total Users", value: "\(totalUsers)", color: .blue, icon: "person.3")
                    AdminStatCard(title: "Properties", value: "\(totalProperties)", color: .green, icon: "building.2")
                    AdminStatCard(title: "Vacant", value: "\(vacantCount)", color: .orange, icon: "house")
                    AdminStatCard(title: "Occupied", value: "\(totalProperties - vacantCount)", color: .purple, icon: "person.2")
                }
                .padding(.horizontal)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Actions")
                        .font(.title2.bold())
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        QuickActionCard(title: "Add Property", icon: "plus.circle", color: .blue)
                        QuickActionCard(title: "View Users", icon: "person.3", color: .green)
                        QuickActionCard(title: "Reports", icon: "chart.bar", color: .orange)
                        QuickActionCard(title: "Settings", icon: "gearshape", color: .purple)
                    }
                    .padding(.horizontal)
                }
                
                // Recent Properties
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Recent Properties")
                            .font(.title2.bold())
                        Spacer()
                        Button("View All") { }
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(propertyVM.properties.prefix(3)) { property in
                            AdminPropertyRow(property: property)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Admin Panel")
        .onAppear {
            totalProperties = propertyVM.properties.count
            totalUsers = LocalDataService.shared.load([AppUser].self, from: AppConstants.Files.users)?.count ?? 0
            vacantCount = propertyVM.properties.filter { $0.status == "vacant" }.count
        }
    }
}

struct AdminPropertyRow: View {
    let property: PropertyModel
    
    var body: some View {
        HStack {
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
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
                
                Text(property.status.capitalized)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(property.status == "vacant" ? .green : .orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct AdminStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title.bold())
                    .foregroundColor(.primary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

struct TimeFrameButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(12)
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        AdminDashboardView()
    }
    .environmentObject(AuthViewModel())
    .environmentObject(PropertyViewModel())
}
