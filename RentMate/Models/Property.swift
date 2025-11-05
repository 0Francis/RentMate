import Foundation
import CoreLocation

struct PropertyModel: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var address: String
    var rent: Double
    var landlordId: String
    var tenants: [String]
    var status: String

    var location: CLLocationCoordinate2D {
        let baseLat = -1.2921
        let baseLon = 36.8219
        let lat = baseLat + Double.random(in: -0.02...0.02)
        let lon = baseLon + Double.random(in: -0.02...0.02)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
