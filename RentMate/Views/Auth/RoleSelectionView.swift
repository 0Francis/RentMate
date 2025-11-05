import SwiftUI

struct RoleSelectionView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Binding var isPresented: Bool
    @State private var selectedRole: String? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Choose Your Role")
                    .font(.largeTitle.bold())
                    .padding(.top, 50)

                HStack(spacing: 20) {
                    roleButton(icon: "person.fill", label: "Tenant", role: AppConstants.Roles.tenant)
                    roleButton(icon: "house.fill", label: "Landlord", role: AppConstants.Roles.landlord)
                    roleButton(icon: "shield.fill", label: "Admin", role: AppConstants.Roles.admin)
                }

                Spacer()

                if let selectedRole = selectedRole {
                    Button {
                        authVM.currentUser?.role = selectedRole
                        LocalDataService.shared.saveUser(authVM.currentUser!)
                        isPresented = false
                    } label: {
                        Label("Continue as \(selectedRole.capitalized)", systemImage: "arrow.right.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.gradient)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                    .transition(.opacity)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Select Role")
        }
    }

    // MARK: - Reusable Role Button
    private func roleButton(icon: String, label: String, role: String) -> some View {
        Button {
            selectedRole = role
        } label: {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                Text(label)
                    .font(.headline)
            }
            .frame(width: 100, height: 100)
            .background(selectedRole == role ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(selectedRole == role ? Color.blue : Color.gray, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RoleSelectionView(isPresented: .constant(true))
        .environmentObject(AuthViewModel())
}
