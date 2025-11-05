import Foundation

final class LocalDataService {
    static let shared = LocalDataService()
    private init() {}
    
    // MARK: - File Paths
    
    private func url(for filename: String) -> URL {
        let manager = FileManager.default
        let docs = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent(filename)
    }

    // MARK: - Load / Save Generic Methods

    func load<T: Decodable>(_ type: T.Type, from filename: String) -> T? {
        let fileURL = url(for: filename)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Error loading \(filename):", error)
            return nil
        }
    }

    func save<T: Encodable>(_ object: T, to filename: String) {
        let fileURL = url(for: filename)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL, options: .atomic)
            // print("✅ Saved \(filename) -> \(fileURL.lastPathComponent)")
        } catch {
            print("❌ Error saving \(filename):", error)
        }
    }
    
    // MARK: - User Save / Load (Convenience)

    func saveUser(_ user: AppUser) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }

    func loadUser() -> AppUser? {
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let decoded = try? JSONDecoder().decode(AppUser.self, from: data) {
            return decoded
        }
        return nil
    }

    func clearUser() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }

    // MARK: - Seed Data (Runs Once on Launch)

    func seedIfNeeded() {
        // Seed properties
        if load([PropertyModel].self, from: AppConstants.Files.properties) == nil {
            let sampleProps = [
                PropertyModel(
                    id: UUID().uuidString,
                    title: "Blue Roof House",
                    address: "12 Blue St, Nairobi",
                    rent: 12000,
                    landlordId: "landlord-1",
                    tenants: [],
                    status: "vacant"
                ),
                PropertyModel(
                    id: UUID().uuidString,
                    title: "Studio 5 Apartments",
                    address: "4 Market Ave, Nairobi",
                    rent: 8000,
                    landlordId: "landlord-2",
                    tenants: [],
                    status: "occupied"
                )
            ]
            save(sampleProps, to: AppConstants.Files.properties)
        }
        
        // Seed payments
        if load([PaymentModel].self, from: AppConstants.Files.payments) == nil {
            save([PaymentModel](), to: AppConstants.Files.payments)
        }
        
        // Seed maintenance
        if load([MaintenanceModel].self, from: AppConstants.Files.maintenance) == nil {
            save([MaintenanceModel](), to: AppConstants.Files.maintenance)
        }
        
        // Seed users
        if load([AppUser].self, from: AppConstants.Files.users) == nil {
            save(MockData.demoUsers, to: AppConstants.Files.users)
        }
    }
}
