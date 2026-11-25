
import SwiftUI

struct AddSubscriptionView: View {

    @ObservedObject var subscriptionViewModel: SubscriptionViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var serviceName = ""
    @State private var category: SubscriptionCategory = .entertainment
    @State private var cost = ""
    @State private var billingCycle: BillingCycle = .monthly
    @State private var startDate = Date()
    @State private var notes = ""
    @State private var status: SubscriptionStatus = .active
    @State private var errorMessage: String?

    var body: some View {

        NavigationStack {

            Form {

                Section("Subscription Details") {

                    TextField("Service Name", text: $serviceName)

                    Picker("Category", selection: $category) {
                        ForEach(SubscriptionCategory.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }

                    TextField("Cost (₹)", text: $cost)
                        .keyboardType(.decimalPad)

                    Picker("Billing Cycle", selection: $billingCycle) {
                        ForEach(BillingCycle.allCases) { cycle in
                            Text(cycle.rawValue).tag(cycle)
                        }
                    }

                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    )
                }

                Section("Additional Information") {

                    Picker("Status", selection: $status) {
                        ForEach(SubscriptionStatus.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }

                    TextField("Notes (Optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                Section {
                    Button {
                        saveSubscription()
                    } label: {
                        Text("Save Subscription")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(.purple)
                    }
                }
            }
        }
    }

    // MARK: - Save Subscription

    private func saveSubscription() {

        guard !serviceName.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            errorMessage = "Please enter a service name."
            return
        }

        guard let subscriptionCost = Double(cost),
              subscriptionCost > 0 else {
            errorMessage = "Please enter a valid cost."
            return
        }

        let newSubscription = Subscription(
            serviceName: serviceName,
            category: category,
            cost: subscriptionCost,
            billingCycle: billingCycle,
            startDate: startDate,
            notes: notes,
            status: status
        )

        subscriptionViewModel.addSubscription(newSubscription)
        dismiss()
    }
}

#Preview {
    AddSubscriptionView(
        subscriptionViewModel: SubscriptionViewModel()
    )
}
