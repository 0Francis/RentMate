import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUser: AppUser? = nil
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    private let localService = LocalDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Listen for persisted user
    init() {
        if let savedUser = localService.loadUser() {
            currentUser = savedUser
            isSignedIn = true
            print("✅ Auto-login successful for: \(savedUser.email)")
        }
    }
    
    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String, role: String) {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        // Load existing users
        var allUsers = localService.load([AppUser].self, from: AppConstants.Files.users) ?? []
        
        // Check if user already exists
        if allUsers.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            errorMessage = "User with this email already exists."
            return
        }

        let newUser = AppUser(
            id: UUID().uuidString,
            name: name,
            email: email,
            role: role
        )
        
        // Add to users list and save
        allUsers.append(newUser)
        localService.save(allUsers, to: AppConstants.Files.users)
        
        // Save as current user
        localService.saveUser(newUser)
        currentUser = newUser
        isSignedIn = true
        errorMessage = ""
        
        print("✅ New user created: \(email) (\(role))")
        print("📊 Total users in system: \(allUsers.count)")
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }

        // Load all users from database
        let allUsers = localService.load([AppUser].self, from: AppConstants.Files.users) ?? []
        
        print("🔍 Searching for user: \(email)")
        print("📊 Users in database: \(allUsers.count)")
        allUsers.forEach { user in
            print("   - \(user.email) (\(user.role))")
        }

        // Find user by email
        if let user = allUsers.first(where: { $0.email.lowercased() == email.lowercased() }) {
            // In real app, you'd verify password hash here
            localService.saveUser(user)
            currentUser = user
            isSignedIn = true
            errorMessage = ""
            print("✅ Login successful for: \(user.email)")
        } else {
            errorMessage = "No account found with this email. Please sign up first."
            print("❌ Login failed: No user found with email \(email)")
        }
    }
    
    // MARK: - Debug Methods
    func printAllUsers() {
        let allUsers = localService.load([AppUser].self, from: AppConstants.Files.users) ?? []
        print("=== ALL USERS IN DATABASE ===")
        print("Total users: \(allUsers.count)")
        allUsers.forEach { user in
            print("ID: \(user.id)")
            print("Name: \(user.name)")
            print("Email: \(user.email)")
            print("Role: \(user.role)")
            print("---")
        }
    }
    
    func clearAllUsers() {
        localService.save([AppUser](), to: AppConstants.Files.users)
        print("🗑️ All users cleared from database")
    }
    
    // MARK: - Update Role
    func updateRole(_ newRole: String) {
        guard var user = currentUser else { return }
        user.role = newRole
        localService.saveUser(user)
        currentUser = user
    }

    // MARK: - Sign Out
    func signOut() {
        localService.clearUser()
        currentUser = nil
        isSignedIn = false
        errorMessage = ""
        print("🚪 User signed out")
    }
    
    // MARK: - Clear Error
    func clearError() {
        errorMessage = ""
    }
}
