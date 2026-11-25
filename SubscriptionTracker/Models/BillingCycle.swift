import Foundation

enum BillingCycle: String, CaseIterable, Identifiable, Codable  {

    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case yearly = "Yearly"

    var id: String {
        rawValue
    }

    var months: Double {
        switch self {
        case .monthly:
            return 1
        case .quarterly:
            return 3
        case .yearly:
            return 12
        }
    }
}
