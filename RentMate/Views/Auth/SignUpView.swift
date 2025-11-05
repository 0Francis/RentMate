import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = "tenant"

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.title.bold())
                    Text("Join RentMate today")
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Role Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("I am a:")
                        .font(.headline)
                    
                    Picker("Role", selection: $selectedRole) {
                        Text("Tenant").tag("tenant")
                        Text("Landlord").tag("landlord")
                        Text("Admin").tag("admin")
                    }
                    .pickerStyle(.segmented)
                }
                
                // Form
                VStack(spacing: 16) {
                    AppTextField(placeholder: "Full Name", text: $name)
                        .textContentType(.name)
                    
                    AppTextField(placeholder: "Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    AppTextField(placeholder: "Password", text: $password, isSecure: true)
                        .textContentType(.newPassword)
                    
                    if !authVM.errorMessage.isEmpty {
                        Text(authVM.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                // Actions
                VStack(spacing: 16) {
                    Button("Create Account") {
                        authVM.signUp(name: name, email: email, password: password, role: selectedRole)
                    }
                    .buttonStyle(AppButtonStyle(isPrimary: true))
                    
                    Button("Already have an account? Sign In") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .font(.subheadline)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: authVM.isSignedIn) { signedIn in
                if signedIn {
                    dismiss()
                }
            }
            .onAppear {
                print("=== SIGNUP VIEW APPEARED ===")
                authVM.printAllUsers()
            }
        }
    }
}
