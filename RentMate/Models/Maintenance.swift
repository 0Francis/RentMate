import Foundation

struct MaintenanceModel: Identifiable, Codable {
    var id: String
    var propertyId: String
    var description: String
    var dateReported: Date
    var status: String

    var formattedDate: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: dateReported)
    }

    var isResolved: Bool {
        status.lowercased() == "resolved"
    }
}
