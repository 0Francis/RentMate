import Foundation

struct PaymentModel: Identifiable, Codable, Equatable {
    var id: String
    var propertyId: String
    var amount: Double
    var date: Date
    var tenantId: String

    var formattedDate: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }

    var formattedAmount: String {
        String(format: "KES %.0f", amount)
    }
}
