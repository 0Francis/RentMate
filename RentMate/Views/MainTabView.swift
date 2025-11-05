import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    
    var body: some View {
        Group {
            switch authVM.currentUser?.role {
            case "landlord":
                LandlordTabView()
            case "admin":
                AdminTabView()
            default: 
                TenantTabView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(PropertyViewModel())
}
