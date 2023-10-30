
import Foundation

// Q: should these live somewhere else?

struct ExpenseItem: Codable, Equatable, Identifiable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

enum ExpenseType: String, CaseIterable {
    case personal = "personal"
    case business = "business"
}
