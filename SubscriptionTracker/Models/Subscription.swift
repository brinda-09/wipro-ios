
import Foundation

struct Subscription: Identifiable, Codable {

    var id: UUID = UUID()
    var serviceName: String
    var category: SubscriptionCategory
    var cost: Double
    var billingCycle: BillingCycle
    var startDate: Date
    var notes: String
    var status: SubscriptionStatus

    var monthlyCost: Double {
        guard status == .active else {
            return 0
        }

        return cost / billingCycle.months
    }
    
    var nextRenewalDate: Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: startDate)

        let monthsToAdd = Int(billingCycle.months)

        // The first renewal is one billing cycle after the start date.
        var renewalDate = calendar.date(
            byAdding: .month,
            value: monthsToAdd,
            to: start
        ) ?? start

        // Move forward until the next renewal is today or in the future.
        while renewalDate < today {
            renewalDate = calendar.date(
                byAdding: .month,
                value: monthsToAdd,
                to: renewalDate
            ) ?? renewalDate
        }

        return renewalDate
    }


    // Only encode stored properties
    enum CodingKeys: String, CodingKey {
        case id
        case serviceName
        case category
        case cost
        case billingCycle
        case startDate
        case notes
        case status
    }
}
