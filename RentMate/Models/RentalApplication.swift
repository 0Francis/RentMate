import Foundation

struct RentalApplication: Identifiable, Codable {
    var id: String
    var propertyId: String
    var tenantId: String
    var applicationDate: Date
    var status: String // pending, approved, rejected
    var tenantName: String
    var tenantEmail: String
    var monthlyIncome: Double
    var employmentStatus: String
    var notes: String?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: applicationDate)
    }
    
    var isPending: Bool {
        status.lowercased() == "pending"
    }
}
