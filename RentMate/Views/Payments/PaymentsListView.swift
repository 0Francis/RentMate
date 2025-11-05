import SwiftUI

struct PaymentsListView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var payments: [PaymentModel] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Payments")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if payments.isEmpty {
                    EmptyPaymentsView()
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(payments) { payment in
                            PaymentCard(payment: payment)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Payments")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            loadPayments()
        }
    }
    
    private func loadPayments() {
        payments = LocalDataService.shared.load([PaymentModel].self, from: AppConstants.Files.payments) ?? []
        
        // If no payments, create some sample data for demo
        if payments.isEmpty {
            payments = createSamplePayments()
        }
    }
    
    private func createSamplePayments() -> [PaymentModel] {
        let samplePayments = [
            PaymentModel(
                id: UUID().uuidString,
                propertyId: "property-1",
                amount: 12000,
                date: Date().addingTimeInterval(-30 * 24 * 3600), // 1 month ago
                tenantId: authVM.currentUser?.id ?? "tenant-1"
            ),
            PaymentModel(
                id: UUID().uuidString,
                propertyId: "property-2",
                amount: 8000,
                date: Date(), // Current date
                tenantId: authVM.currentUser?.id ?? "tenant-1"
            )
        ]
        return samplePayments
    }
}

struct PaymentCard: View {
    let payment: PaymentModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Rent Payment")
                    .font(.headline)
                
                Text(payment.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Property #\(payment.propertyId.prefix(8))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(payment.formattedAmount)
                    .font(.title3.bold())
                    .foregroundColor(.green)
                
                Text("Paid")
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

struct EmptyPaymentsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Payments")
                    .font(.headline)
                Text("Your payment history will appear here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        PaymentsListView()
            .environmentObject(AuthViewModel())
    }
}
