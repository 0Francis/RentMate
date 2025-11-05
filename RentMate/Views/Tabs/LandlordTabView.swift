import SwiftUI

struct LandlordTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Properties Management
            NavigationStack {
                LandlordDashboardView()
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "building.2.fill" : "building.2")
                Text("Properties")
            }
            .tag(0)
            
            // Tab 2: Payments
            NavigationStack {
                PaymentsListView()
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "creditcard.fill" : "creditcard")
                Text("Payments")
            }
            .tag(1)
            
            // Tab 3: Maintenance
            NavigationStack {
                MaintenanceListView()
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "wrench.and.screwdriver.fill" : "wrench.and.screwdriver")
                Text("Maintenance")
            }
            .tag(2)
            
            // Tab 4: Analytics
            NavigationStack {
                LandlordAnalyticsView()
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                Text("Analytics")
            }
            .tag(3)
            
            // Tab 5: Profile
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: selectedTab == 4 ? "person.crop.circle.fill" : "person.crop.circle")
                Text("Profile")
            }
            .tag(4)
        }
        .accentColor(Color("RentMateBlueDeep"))
        .onAppear {
            setupTabBarAppearance()
            propertyVM.loadLocalProperties()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// Landlord Analytics View
struct LandlordAnalyticsView: View {
    @EnvironmentObject var propertyVM: PropertyViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Property Analytics")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Stats Overview
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    AnalyticsCard(title: "Total Properties", value: "\(propertyVM.properties.count)", color: .blue, icon: "building.2")
                    AnalyticsCard(title: "Vacant", value: "\(propertyVM.properties.filter { $0.status == "vacant" }.count)", color: .green, icon: "house")
                    AnalyticsCard(title: "Occupied", value: "\(propertyVM.properties.filter { $0.status == "occupied" }.count)", color: .orange, icon: "person.2")
                    AnalyticsCard(title: "Monthly Revenue", value: "Ksh \(propertyVM.properties.filter { $0.status == "occupied" }.reduce(0) { $0 + $1.rent })", color: .purple, icon: "dollarsign.circle")
                }
                .padding(.horizontal)
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(propertyVM.properties.prefix(3)) { property in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(property.title)
                                    .font(.subheadline.bold())
                                Text(property.status.capitalized)
                                    .font(.caption)
                                    .foregroundColor(property.status == "vacant" ? .green : .orange)
                            }
                            Spacer()
                            Text("Ksh \(Int(property.rent))")
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Analytics")
        .background(Color(.systemGroupedBackground))
    }
}

struct AnalyticsCard: View {
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
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    LandlordTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(PropertyViewModel())
}
