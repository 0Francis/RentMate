import SwiftUI

struct TenantTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    @State private var selectedTab = 0
    @State private var hasActiveLease = false
    @State private var applications: [RentalApplication] = []
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Browse Properties (Home)
            NavigationStack {
                if hasActiveLease {
                    TenantDashboardView()
                } else {
                    TenantBrowseView(
                        hasActiveLease: $hasActiveLease,
                        applications: $applications
                    )
                }
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("Home")
            }
            .tag(0)
            
            // Tab 2: Applications
            NavigationStack {
                ApplicationsTabView(applications: applications)
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "doc.text.fill" : "doc.text")
                Text("Applications")
            }
            .tag(1)
            
            // Tab 3: Favorites/Saved Properties
            NavigationStack {
                SavedPropertiesView()
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "heart.fill" : "heart")
                Text("Saved")
            }
            .tag(2)
            
            // Tab 4: Profile & Settings
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "person.crop.circle.fill" : "person.crop.circle")
                Text("Profile")
            }
            .tag(3)
        }
        .accentColor(Color("RentMateBlueDeep"))
        .onAppear {
            setupTabBarAppearance()
            checkActiveLease()
            loadApplications()
            propertyVM.loadLocalProperties()
        }
    }
    
    private func checkActiveLease() {
        // In real app, check if tenant has active lease
        // For demo, we'll use a simple check
        hasActiveLease = UserDefaults.standard.bool(forKey: "hasActiveLease")
    }
    
    private func loadApplications() {
        applications = LocalDataService.shared.load([RentalApplication].self, from: "applications") ?? []
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    TenantTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(PropertyViewModel())
}
