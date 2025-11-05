import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var propertyVM: PropertyViewModel
    
    var body: some View {
        Group {
            if authVM.isSignedIn {
                MainTabView()
            } else {
                LandingView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authVM.isSignedIn)
    }
}
