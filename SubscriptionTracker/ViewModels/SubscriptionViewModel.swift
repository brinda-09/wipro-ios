
import Foundation
import Combine

@MainActor
final class SubscriptionViewModel: ObservableObject {

    // MARK: - Storage Key
    private let storageKey = "savedSubscriptions"

    // MARK: - Subscription Data
    @Published private(set) var subscriptions: [Subscription] = []

    // MARK: - Search and Filter
    @Published var searchText: String = ""
    @Published var selectedCategory: SubscriptionCategory? = nil
    @Published var selectedStatus: SubscriptionStatus? = nil

    // MARK: - Initialization
    init() {
        loadSubscriptions()
    }

    // MARK: - Add Subscription
    func addSubscription(_ subscription: Subscription) {
        subscriptions.append(subscription)
        saveSubscriptions()
    }

    // MARK: - Update Subscription
    func updateSubscription(_ updatedSubscription: Subscription) {
        guard let index = subscriptions.firstIndex(
            where: { $0.id == updatedSubscription.id }
        ) else {
            return
        }

        subscriptions[index] = updatedSubscription
        saveSubscriptions()
    }

    // MARK: - Delete Subscription
    func deleteSubscription(id: UUID) {
        subscriptions.removeAll {
            $0.id == id
        }

        saveSubscriptions()
    }

    // MARK: - Total Subscriptions
    var totalSubscriptions: Int {
        subscriptions.count
    }

    // MARK: - Active Subscriptions
    var activeSubscriptionsCount: Int {
        subscriptions.filter {
            $0.status == .active
        }.count
    }

    // MARK: - Monthly Spending
    var monthlySpending: Double {
        subscriptions.reduce(0) {
            $0 + $1.monthlyCost
        }
    }
    var upcomingSubscriptions: [Subscription] {
        let today = Calendar.current.startOfDay(for: Date())

        let next30Days = Calendar.current.date(
            byAdding: .day,
            value: 30,
            to: today
        ) ?? today

        return subscriptions
            .filter {
                $0.status == .active &&
                $0.nextRenewalDate >= today &&
                $0.nextRenewalDate <= next30Days
            }
            .sorted {
                $0.nextRenewalDate < $1.nextRenewalDate
            }
    }

    // MARK: - Filtered Subscriptions
    var filteredSubscriptions: [Subscription] {
        subscriptions.filter { subscription in

            let matchesSearch =
                searchText.isEmpty ||
                subscription.serviceName.localizedCaseInsensitiveContains(searchText)

            let matchesCategory =
                selectedCategory == nil ||
                subscription.category == selectedCategory

            let matchesStatus =
                selectedStatus == nil ||
                subscription.status == selectedStatus

            return matchesSearch && matchesCategory && matchesStatus
        }
    }

    // MARK: - Save Data
    private func saveSubscriptions() {
        do {
            let data = try JSONEncoder().encode(subscriptions)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Error saving subscriptions: \(error.localizedDescription)")
        }
    }

    // MARK: - Load Data
    private func loadSubscriptions() {
        guard let data = UserDefaults.standard.data(
            forKey: storageKey
        ) else {
            return
        }

        do {
            subscriptions = try JSONDecoder().decode(
                [Subscription].self,
                from: data
            )
        } catch {
            print("Error loading subscriptions: \(error.localizedDescription)")
        }
    }
    // MARK: - Spending by Category

    func spending(for category: SubscriptionCategory) -> Double {
        subscriptions
            .filter {
                $0.category == category && $0.status == .active
            }
            .reduce(0) {
                $0 + $1.monthlyCost
            }
    }
}
