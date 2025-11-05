import SwiftUI
import MapKit

struct TenantDashboardView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -1.286389, longitude: 36.817223),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var searchText = ""
    
    var filteredProperties: [PropertyModel] {
        if searchText.isEmpty {
            return propertyVM.properties
        } else {
            return propertyVM.properties.filter { property in
                property.title.localizedCaseInsensitiveContains(searchText) ||
                property.address.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with Welcome
                VStack(alignment: .leading, spacing: 8) {
                    Text("Find Your Dream Home")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                    
                    Text("Discover amazing properties around you")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search properties...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Map Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Explore Map")
                            .font(.title2.bold())
                        Spacer()
                        Button("View All") {
                            // Action for viewing all on map
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                    }
                    
                    Map(coordinateRegion: $region)
                        .frame(height: 200)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                // Properties Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Available Properties")
                            .font(.title2.bold())
                        Spacer()
                        Text("\(filteredProperties.count) found")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    LazyVStack(spacing: 16) {
                        ForEach(filteredProperties) { property in
                            PropertyCard(property: property)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Tenant Dashboard")
    }
}

struct PropertyCard: View {
    let property: PropertyModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Property Image
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue.opacity(0.2))
                .frame(height: 160)
                .overlay(
                    Image(systemName: "house.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(property.title)
                    .font(.headline)
                    .lineLimit(1)
                
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
                    Text("Ksh \(Int(property.rent))")
                        .font(.title3.bold())
                        .foregroundColor(.blue)
                    Text("/ month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Capsule()
                        .fill(property.status == "vacant" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                        .frame(width: 80, height: 24)
                        .overlay(
                            Text(property.status.capitalized)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(property.status == "vacant" ? .green : .orange)
                        )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        TenantDashboardView()
    }
    .environmentObject(AuthViewModel())
    .environmentObject(PropertyViewModel())
}
