import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var showDebugMenu = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Welcome Back")
                        .font(.title.bold())
                    Text("Sign in to your account")
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Form
                VStack(spacing: 16) {
                    AppTextField(placeholder: "Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    AppTextField(placeholder: "Password", text: $password, isSecure: true)
                        .textContentType(.password)
                    
                    if !authVM.errorMessage.isEmpty {
                        Text(authVM.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                // Actions
                VStack(spacing: 16) {
                    Button("Sign In") {
                        authVM.signIn(email: email, password: password)
                    }
                    .buttonStyle(AppButtonStyle(isPrimary: true))
                    
                    Button("Don't have an account? Sign Up") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .font(.subheadline)
                    
                    // Debug button (hidden by default)
                    Button("Debug") {
                        showDebugMenu = true
                    }
                    .foregroundColor(.gray)
                    .font(.caption)
                    .opacity(0.5)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign In")
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
            .sheet(isPresented: $showDebugMenu) {
                DebugAuthView()
            }
            .onAppear {
                // Print current state for debugging
                print("=== LOGIN VIEW APPEARED ===")
                authVM.printAllUsers()
            }
        }
    }
}

// Debug View to see all accounts
struct DebugAuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Debug Actions") {
                    Button("Print All Users to Console") {
                        authVM.printAllUsers()
                    }
                    
                    Button("Clear All Users") {
                        authVM.clearAllUsers()
                    }
                    .foregroundColor(.red)
                }
                
                Section("Current Auth State") {
                    HStack {
                        Text("Is Signed In")
                        Spacer()
                        Text(authVM.isSignedIn ? "Yes" : "No")
                            .foregroundColor(authVM.isSignedIn ? .green : .red)
                    }
                    
                    if let user = authVM.currentUser {
                        VStack(alignment: .leading) {
                            Text("Current User:")
                                .font(.headline)
                            Text("Name: \(user.name)")
                            Text("Email: \(user.email)")
                            Text("Role: \(user.role)")
                        }
                    } else {
                        Text("No current user")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Debug Auth")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
