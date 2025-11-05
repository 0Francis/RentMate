import Foundation

@MainActor
final class PaymentViewModel: ObservableObject {
    @Published var payments: [PaymentModel] = []

    init() {
        loadPayments()
    }

    func loadPayments() {
        payments = LocalDataService.shared.load([PaymentModel].self, from: AppConstants.Files.payments) ?? []
    }

    func addPayment(propertyId: String, amount: Double, tenantId: String) {
        let p = PaymentModel(id: UUID().uuidString, propertyId: propertyId, amount: amount, date: Date(), tenantId: tenantId)
        payments.append(p)
        LocalDataService.shared.save(payments, to: AppConstants.Files.payments)
    }

    func deletePayment(id: String) {
        payments.removeAll { $0.id == id }
        LocalDataService.shared.save(payments, to: AppConstants.Files.payments)
    }

    func payments(for tenantId: String) -> [PaymentModel] {
        payments.filter { $0.tenantId == tenantId }
    }
}
