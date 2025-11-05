import Foundation

@MainActor
final class PropertyViewModel: ObservableObject {
    @Published var properties: [PropertyModel] = []
    private let storage = LocalDataService.shared
    private let filename = AppConstants.Files.properties

    init() {
        fetchProperties()
    }

    func fetchProperties() {
        properties = storage.load([PropertyModel].self, from: filename) ?? []
    }

    func addProperty(title: String, address: String, rent: Double, landlordId: String) {
        let p = PropertyModel(
            id: UUID().uuidString,
            title: title,
            address: address,
            rent: rent,
            landlordId: landlordId,
            tenants: [],
            status: "vacant"
        )
        properties.append(p)
        storage.save(properties, to: filename)
    }

    func deleteProperty(id: String) {
        properties.removeAll { $0.id == id }
        storage.save(properties, to: filename)
    }
    
    func loadLocalProperties() {
        if let loaded = LocalDataService.shared.load([PropertyModel].self, from: AppConstants.Files.properties) {
            properties = loaded
        }
    }

    func addLocalProperty(title: String, address: String, rent: Double) {
        var props = LocalDataService.shared.load([PropertyModel].self, from: AppConstants.Files.properties) ?? []
        let new = PropertyModel(id: UUID().uuidString, title: title, address: address, rent: rent, landlordId: "local", tenants: [], status: "vacant")
        props.append(new)
        LocalDataService.shared.save(props, to: AppConstants.Files.properties)
        properties = props
    }
}
