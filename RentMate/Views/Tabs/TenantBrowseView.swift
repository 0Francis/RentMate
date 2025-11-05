import SwiftUI

struct TenantBrowseView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    @Binding var hasActiveLease: Bool
    @Binding var applications: [RentalApplication]
    
    @State private var searchText = ""
    @State private var selectedProperty: PropertyModel?
    @State private var showApplicationSheet = false
    @State private var showApplicationHistory = false
    @State private var showContactLandlord = false
    
    // Explicit initializer to resolve ambiguity
    init(hasActiveLease: Binding<Bool>, applications: Binding<[RentalApplication]>) {
        self._hasActiveLease = hasActiveLease
        self._applications = applications
    }
    
    var availableProperties: [PropertyModel] {
        propertyVM.properties.filter { $0.status == "vacant" }
    }
    
    var filteredProperties: [PropertyModel] {
        if searchText.isEmpty {
            return availableProperties
        } else {
            return availableProperties.filter { property in
                property.title.localizedCaseInsensitiveContains(searchText) ||
                property.address.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Find Your New Home")
                            .font(.title.bold())
                        
                        Text("Browse available properties and apply for rentals")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search by location or property name...", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Application Status
                    if !applications.isEmpty {
                        applicationStatusSection
                            .padding(.horizontal)
                    }
                    
                    // Available Properties
                    if filteredProperties.isEmpty {
                        noPropertiesAvailableView
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Available Properties (\(filteredProperties.count))")
                                    .font(.title2.bold())
                                
                                Spacer()
                                
                                Button("View Applications") {
                                    showApplicationHistory = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .opacity(applications.isEmpty ? 0 : 1)
                            }
                            .padding(.horizontal)
                            
                            LazyVStack(spacing: 16) {
                                ForEach(filteredProperties) { property in
                                    propertyBrowseCard(property: property)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Contact Landlord Option
                    Button("Contact a Landlord") {
                        showContactLandlord = true
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Browse Properties")
            .sheet(isPresented: $showApplicationSheet) {
                if let property = selectedProperty {
                    RentalApplicationView(
                        property: property,
                        isPresented: $showApplicationSheet,
                        onApplicationSubmitted: { newApplication in
                            applications.append(newApplication)
                        }
                    )
                }
            }
            .sheet(isPresented: $showApplicationHistory) {
                ApplicationHistoryView(
                    applications: applications,
                    isPresented: $showApplicationHistory
                )
            }
            .sheet(isPresented: $showContactLandlord) {
                ContactLandlordView()
            }
        }
    }
    
    // MARK: - Computed Views
    
    private var applicationStatusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your Applications")
                    .font(.headline)
                
                Spacer()
                
                Button("View All") {
                    showApplicationHistory = true
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            HStack {
                applicationStatusItem(
                    count: applications.filter { $0.status == "pending" }.count,
                    title: "Pending",
                    color: .orange,
                    icon: "clock.fill"
                )
                
                applicationStatusItem(
                    count: applications.filter { $0.status == "approved" }.count,
                    title: "Approved",
                    color: .green,
                    icon: "checkmark.circle.fill"
                )
                
                applicationStatusItem(
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
    
    private func applicationStatusItem(count: Int, title: String, color: Color, icon: String) -> some View {
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
    
    private var noPropertiesAvailableView: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.lodge")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Properties Available")
                    .font(.headline)
                Text("Check back later for new rental opportunities in your area.")
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
    
    private func propertyBrowseCard(property: PropertyModel) -> some View {
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
                        
                        Text("Available Now")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(6)
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
                    
                    Button("Apply Now") {
                        selectedProperty = property
                        showApplicationSheet = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(width: 120)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    TenantBrowseView(
        hasActiveLease: .constant(false),
        applications: .constant([])
    )
    .environmentObject(AuthViewModel())
    .environmentObject(PropertyViewModel())
}
