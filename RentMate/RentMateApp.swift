import SwiftUI

@main
struct RentMateApp: App {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var propertyVM = PropertyViewModel()

    init() {
        LocalDataService.shared.seedIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .environmentObject(propertyVM)
        }
    }
}
