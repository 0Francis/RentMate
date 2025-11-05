import SwiftUI
import CoreLocation

struct LandlordDashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    @State private var showAddSheet = false
    @State private var selectedFilter = "All"

    var filteredProperties: [PropertyModel] {
        switch selectedFilter {
        case "Vacant":
            return propertyVM.properties.filter { $0.status == "vacant" }
        case "Occupied":
            return propertyVM.properties.filter { $0.status == "occupied" }
        default:
            return propertyVM.properties
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Stats Overview
                HStack(spacing: 15) {
                    StatCard(title: "Total", value: "\(propertyVM.properties.count)", color: .blue, icon: "building.2")
                    StatCard(title: "Vacant", value: "\(propertyVM.properties.filter { $0.status == "vacant" }.count)", color: .green, icon: "house")
                    StatCard(title: "Occupied", value: "\(propertyVM.properties.filter { $0.status == "occupied" }.count)", color: .orange, icon: "person.2")
                }
                .padding(.horizontal)
                
                // Filter Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterButton(title: "All", isSelected: selectedFilter == "All") {
                            selectedFilter = "All"
                        }
                        FilterButton(title: "Vacant", isSelected: selectedFilter == "Vacant") {
                            selectedFilter = "Vacant"
                        }
                        FilterButton(title: "Occupied", isSelected: selectedFilter == "Occupied") {
                            selectedFilter = "Occupied"
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Properties List
                if filteredProperties.isEmpty {
                    EmptyStateView(
                        title: "No Properties",
                        message: propertyVM.properties.isEmpty ?
                            "Add your first property to get started" :
                            "No properties match your filter",
                        action: { showAddSheet = true },
                        showAction: propertyVM.properties.isEmpty
                    )
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredProperties) { property in
                            LandlordPropertyCard(property: property)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Properties")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddPropertyView(isPresented: $showAddSheet)
                .environmentObject(propertyVM)
        }
    }
}

struct LandlordPropertyCard: View {
    let property: PropertyModel
    
    var body: some View {
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
                
                Text(property.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("Ksh \(Int(property.rent))")
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Capsule()
                        .fill(property.status == "vacant" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                        .frame(width: 70, height: 24)
                        .overlay(
                            Text(property.status.capitalized)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(property.status == "vacant" ? .green : .orange)
                        )
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String
    let action: () -> Void
    let showAction: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.lodge")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if showAction {
                Button(action: action) {
                    Label("Add Property", systemImage: "plus.circle.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        LandlordDashboardView()
    }
    .environmentObject(AuthViewModel())
    .environmentObject(PropertyViewModel())
}
