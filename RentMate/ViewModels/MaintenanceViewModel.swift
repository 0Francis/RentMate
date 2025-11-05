import Foundation

@MainActor
final class MaintenanceViewModel: ObservableObject {
    @Published var requests: [MaintenanceModel] = []

    init() {
        loadRequests()
    }

    func loadRequests() {
        requests = LocalDataService.shared.load([MaintenanceModel].self, from: AppConstants.Files.maintenance) ?? []
    }

    func addRequest(propertyId: String, requestBy: String, description: String) {
        let r = MaintenanceModel(id: UUID().uuidString, propertyId: propertyId, description: description, dateReported: Date(), status: "open")
        requests.append(r)
        LocalDataService.shared.save(requests, to: AppConstants.Files.maintenance)
    }

    func updateStatus(id: String, to newStatus: String) {
        if let i = requests.firstIndex(where: { $0.id == id }) {
            requests[i].status = newStatus
            LocalDataService.shared.save(requests, to: AppConstants.Files.maintenance)
        }
    }

    func deleteRequest(id: String) {
        requests.removeAll { $0.id == id }
        LocalDataService.shared.save(requests, to: AppConstants.Files.maintenance)
    }
}
