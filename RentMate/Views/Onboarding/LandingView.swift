import SwiftUI
import MapKit

struct LandingView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -1.286389, longitude: 36.817223),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var showSignup = false
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [Color.rentMateBlueDeep, Color.rentMateBlueLight],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // App Logo/Title
                    VStack(spacing: 16) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("RentMate")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Find Your Perfect Home")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    // Map Preview
                    Map(coordinateRegion: $region)
                        .cornerRadius(20)
                        .frame(height: 200)
                        .shadow(radius: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        Button("Get Started") {
                            showSignup = true
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Button("I Already Have an Account") {
                            showLogin = true
                        }
                        .font(.headline)
                        .foregroundColor(Color.rentMateBlueDeep)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                        .italic()
                        
                        Button("Explore as Guest") {
                            signInAsGuest()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showSignup) {
                SignupView()
                    .environmentObject(authVM)
            }
            .sheet(isPresented: $showLogin) {
                LoginView()
                    .environmentObject(authVM)
            }
        }
    }
    
    private func signInAsGuest() {
        let guestUser = AppUser(
            id: "guest-\(UUID().uuidString)",
            name: "Guest User",
            email: "guest@rentmate.com",
            role: "tenant"
        )
        authVM.currentUser = guestUser
        authVM.isSignedIn = true
    }
}

// Secondary Button Style to complement your PrimaryButtonStyle
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(Color.rentMateBlueDeep)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.rentMateBlueDeep, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

// Plain Button Style for guest mode
struct PlainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(12)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

#Preview {
    LandingView()
        .environmentObject(AuthViewModel())
}
