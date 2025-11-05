import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    VStack(spacing: 4) {
                        Text(authVM.currentUser?.name ?? "Guest User")
                            .font(.title2.bold())
                        Text(authVM.currentUser?.role.capitalized ?? "Tenant")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(authVM.currentUser?.email ?? "guest@rentmate.com")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Menu Items
                LazyVStack(spacing: 12) {
                    ProfileMenuItem(title: "Personal Information", icon: "person", color: .blue)
                    ProfileMenuItem(title: "Payment Methods", icon: "creditcard", color: .green)
                    ProfileMenuItem(title: "Notifications", icon: "bell", color: .orange)
                    ProfileMenuItem(title: "Security", icon: "shield", color: .purple)
                    ProfileMenuItem(title: "Help & Support", icon: "questionmark.circle", color: .red)
                }
                .padding(.horizontal)
                
                // Sign Out Button
                if authVM.currentUser?.id.hasPrefix("guest") != true {
                    Button(action: { authVM.signOut() }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Profile")
        .background(Color(.systemGroupedBackground))
    }
}

struct ProfileMenuItem: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environmentObject(AuthViewModel())
}
