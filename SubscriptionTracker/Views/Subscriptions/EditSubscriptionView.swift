
import SwiftUI

struct EditSubscriptionView: View {

    @ObservedObject var subscriptionViewModel: SubscriptionViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var subscription: Subscription
    @State private var errorMessage: String?
    @State private var showDeleteConfirmation = false

    init(
        subscription: Subscription,
        subscriptionViewModel: SubscriptionViewModel
    ) {
        self.subscriptionViewModel = subscriptionViewModel
        _subscription = State(initialValue: subscription)
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Subscription Details") {

                    TextField(
                        "Service Name",
                        text: $subscription.serviceName
                    )

                    Picker("Category", selection: $subscription.category) {
                        ForEach(SubscriptionCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }

                    TextField(
                        "Cost (₹)",
                        value: $subscription.cost,
                        format: .number
                    )
                    .keyboardType(.decimalPad)

                    Picker(
                        "Billing Cycle",
                        selection: $subscription.billingCycle
                    ) {
                        ForEach(BillingCycle.allCases) { cycle in
                            Text(cycle.rawValue).tag(cycle)
                        }
                    }

                    DatePicker(
                        "Start Date",
                        selection: $subscription.startDate,
                        displayedComponents: .date
                    )
                }

                Section("Additional Information") {

                    Picker("Status", selection: $subscription.status) {
                        ForEach(SubscriptionStatus.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }

                    TextField(
                        "Notes",
                        text: $subscription.notes,
                        axis: .vertical
                    )
                    .lineLimit(3...5)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }

                Section {

                    Button("Save Changes") {
                        saveChanges()
                    }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                }

                Section {

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete Subscription", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Edit Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Delete Subscription?",
                isPresented: $showDeleteConfirmation
            ) {
                Button("Cancel", role: .cancel) { }

                Button("Delete", role: .destructive) {
                    subscriptionViewModel.deleteSubscription(
                        id: subscription.id
                    )
                    dismiss()
                }
            } message: {
                Text("This subscription will be permanently deleted.")
            }
        }
    }

    private func saveChanges() {

        guard !subscription.serviceName.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            errorMessage = "Please enter a service name."
            return
        }

        guard subscription.cost > 0 else {
            errorMessage = "Please enter a valid cost."
            return
        }

        subscriptionViewModel.updateSubscription(subscription)
        dismiss()
    }
}

#Preview {
    EditSubscriptionView(
        subscription: Subscription(
            serviceName: "Netflix",
            category: .entertainment,
            cost: 399,
            billingCycle: .monthly,
            startDate: Date(),
            notes: "",
            status: .active
        ),
        subscriptionViewModel: SubscriptionViewModel()
    )
}
