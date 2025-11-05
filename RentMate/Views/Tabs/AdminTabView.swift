import SwiftUI

struct AdminTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    @State private var selectedTab = 0
    @State private var totalUsers: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Admin Dashboard
            NavigationStack {
                AdminDashboardView()
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "chart.pie.fill" : "chart.pie")
                Text("Dashboard")
            }
            .tag(0)
            
            // Tab 2: User Management
            NavigationStack {
                UserManagementView()
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "person.3.fill" : "person.3")
                Text("Users")
            }
            .tag(1)
            
            // Tab 3: Properties Overview
            NavigationStack {
                AdminPropertiesView()
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "building.2.fill" : "building.2")
                Text("Properties")
            }
            .tag(2)
            
            // Tab 4: Reports
            NavigationStack {
                ReportsView()
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "doc.text.fill" : "doc.text")
                Text("Reports")
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
            loadUserCount()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func loadUserCount() {
        totalUsers = LocalDataService.shared.load([AppUser].self, from: AppConstants.Files.users)?.count ?? 0
    }
}

// User Management View
struct UserManagementView: View {
    @State private var users: [AppUser] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("User Management")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // User Stats
                HStack(spacing: 15) {
                    UserStatCard(title: "Total Users", value: "\(users.count)", color: .blue)
                    UserStatCard(title: "Landlords", value: "\(users.filter { $0.role == "landlord" }.count)", color: .green)
                    UserStatCard(title: "Tenants", value: "\(users.filter { $0.role == "tenant" }.count)", color: .orange)
                }
                .padding(.horizontal)
                
                // Users List
                LazyVStack(spacing: 12) {
                    ForEach(users) { user in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Capsule()
                                .fill(roleColor(user.role).opacity(0.2))
                                .frame(width: 80, height: 24)
                                .overlay(
                                    Text(user.role.capitalized)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(roleColor(user.role))
                                )
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Users")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            loadUsers()
        }
    }
    
    private func loadUsers() {
        users = LocalDataService.shared.load([AppUser].self, from: AppConstants.Files.users) ?? []
    }
    
    private func roleColor(_ role: String) -> Color {
        switch role {
        case "admin": return .red
        case "landlord": return .green
        case "tenant": return .blue
        default: return .gray
        }
    }
}

struct UserStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// Admin Properties View
struct AdminPropertiesView: View {
    @EnvironmentObject var propertyVM: PropertyViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("All Properties")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Property Stats
                HStack(spacing: 15) {
                    PropertyStatCard(title: "Total", value: "\(propertyVM.properties.count)", color: .blue)
                    PropertyStatCard(title: "Vacant", value: "\(propertyVM.properties.filter { $0.status == "vacant" }.count)", color: .green)
                    PropertyStatCard(title: "Occupied", value: "\(propertyVM.properties.filter { $0.status == "occupied" }.count)", color: .orange)
                }
                .padding(.horizontal)
                
                // Properties List
                LazyVStack(spacing: 12) {
                    ForEach(propertyVM.properties) { property in
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
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Properties")
        .background(Color(.systemGroupedBackground))
    }
}

struct PropertyStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// Reports View
struct ReportsView: View {
    @EnvironmentObject var propertyVM: PropertyViewModel
    @State private var users: [AppUser] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Platform Reports")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Summary Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ReportCard(title: "Total Users", value: "\(users.count)", icon: "person.3", color: .blue)
                    ReportCard(title: "Properties", value: "\(propertyVM.properties.count)", icon: "building.2", color: .green)
                    ReportCard(title: "Vacant Units", value: "\(propertyVM.properties.filter { $0.status == "vacant" }.count)", icon: "house", color: .orange)
                    ReportCard(title: "Monthly Revenue", value: "Ksh \(Int(propertyVM.properties.filter { $0.status == "occupied" }.reduce(0) { $0 + $1.rent }))", icon: "dollarsign.circle", color: .purple)
                }
                .padding(.horizontal)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ReportActionCard(title: "Generate Report", icon: "doc.text", color: .blue)
                        ReportActionCard(title: "Export Data", icon: "square.and.arrow.up", color: .green)
                        ReportActionCard(title: "System Logs", icon: "list.bullet.clipboard", color: .orange)
                        ReportActionCard(title: "Backup", icon: "externaldrive", color: .purple)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Reports")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            loadUsers()
        }
    }
    
    private func loadUsers() {
        users = LocalDataService.shared.load([AppUser].self, from: AppConstants.Files.users) ?? []
    }
}

struct ReportCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

struct ReportActionCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Action for report feature
        }) {
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
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AdminTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(PropertyViewModel())
}
