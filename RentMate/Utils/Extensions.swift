import Foundation
import SwiftUI

extension Date {
    func short() -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        return f.string(from: self)
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color(.systemBackground).opacity(0.95))
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}
