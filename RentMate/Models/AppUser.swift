import Foundation

struct AppUser: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var role: String
}
