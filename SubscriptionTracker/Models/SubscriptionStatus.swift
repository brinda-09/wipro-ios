import Foundation

enum SubscriptionStatus: String, CaseIterable, Identifiable, Codable  {

    case active = "Active"
    case paused = "Paused"
    case cancelled = "Cancelled"

    var id: String {
        rawValue
    }
}
