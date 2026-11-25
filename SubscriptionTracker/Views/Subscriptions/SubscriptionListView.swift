
import SwiftUI

struct SubscriptionListView: View {

    @ObservedObject var subscriptionViewModel: SubscriptionViewModel
    @State private var showingAddSubscription = false

    private let purple = Color(red: 0.48, green: 0.16, blue: 0.95)

    var body: some View {

        NavigationStack {

            VStack(spacing: 13) {

                // Search Bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(purple)

                    TextField(
                        "Search subscriptions",
                        text: $subscriptionViewModel.searchText
                    )
                    .tint(purple)
                }
                .padding(14)
                .background(Color.purple.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)

              
                // MARK: - Category Dropdown
                HStack {
                    Text("Category")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Menu {
                        Button("All Categories") {
                            subscriptionViewModel.selectedCategory = nil
                        }

                        ForEach(SubscriptionCategory.allCases) { category in
                            Button(category.rawValue) {
                                subscriptionViewModel.selectedCategory = category
                            }
                        }
                    } label: {
                        HStack {
                            Text(subscriptionViewModel.selectedCategory?.rawValue ?? "All Categories")
                            Image(systemName: "chevron.down")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)

                // Status Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 9) {

                        statusButton(
                            title: "All Statuses",
                            status: nil
                        )

                        ForEach(SubscriptionStatus.allCases) { status in
                            statusButton(
                                title: status.rawValue,
                                status: status
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // Subscription List
                if subscriptionViewModel.filteredSubscriptions.isEmpty {

                    Spacer()

                    Image(systemName: "creditcard")
                        .font(.system(size: 48))
                        .foregroundStyle(purple.opacity(0.7))

                    Text("No subscriptions found")
                        .font(.headline)

                    Text("Try changing your search or filters.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                } else {

                    List {
                        ForEach(
                            subscriptionViewModel.filteredSubscriptions
                        ) { subscription in

                            NavigationLink {
                                EditSubscriptionView(
                                    subscription: subscription,
                                    subscriptionViewModel: subscriptionViewModel
                                )
                            } label: {
                                subscriptionRow(subscription)
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 5,
                                    leading: 14,
                                    bottom: 5,
                                    trailing: 14
                                )
                            )
                        }
                        .onDelete { indexSet in

                            let items =
                                subscriptionViewModel.filteredSubscriptions

                            for index in indexSet {
                                let subscription = items[index]

                                subscriptionViewModel.deleteSubscription(
                                    id: subscription.id
                                )
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.top, 8)
            .background(Color(.systemBackground))
            .navigationTitle("My Subscriptions")
            .navigationBarTitleDisplayMode(.inline)

            // Add Subscription Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSubscription = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(purple)
                            .clipShape(Circle())
                    }
                }
            }

            // Add Subscription Sheet
            .sheet(isPresented: $showingAddSubscription) {
                AddSubscriptionView(
                    subscriptionViewModel: subscriptionViewModel
                )
            }
        }
        .tint(purple)
    }

    // MARK: - Category Filter Button

    private func categoryButton(
        title: String,
        category: SubscriptionCategory?
    ) -> some View {

        let isSelected =
            subscriptionViewModel.selectedCategory == category

        return Button {
            subscriptionViewModel.selectedCategory = category
        } label: {

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 15)
                .padding(.vertical, 9)
                .background(
                    isSelected
                    ? purple
                    : Color.purple.opacity(0.07)
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    // MARK: - Status Filter Button

    private func statusButton(
        title: String,
        status: SubscriptionStatus?
    ) -> some View {

        let isSelected =
            subscriptionViewModel.selectedStatus == status

        return Button {
            subscriptionViewModel.selectedStatus = status
        } label: {

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 15)
                .padding(.vertical, 9)
                .background(
                    isSelected
                    ? purple
                    : Color.purple.opacity(0.07)
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    // MARK: - Subscription Logo

    private func logoName(for serviceName: String) -> String? {

        let name = serviceName.lowercased()

        if name.contains("netflix") {
            return "Netflix"
        } else if name.contains("spotify") {
            return "Spotify"
        } else if name.contains("gcp") || name.contains("google cloud") {
            return "GCP"
        }

        return nil
    }

    // MARK: - Subscription Row

    private func subscriptionRow(
        _ subscription: Subscription
    ) -> some View {

        HStack(spacing: 12) {

            // Service Logo
            Group {
                if let assetName = logoName(for: subscription.serviceName) {

                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .padding(5)

                } else {

                    Image(systemName: "creditcard.fill")
                        .font(.title2)
                        .foregroundStyle(purple)
                }
            }
            .frame(width: 48, height: 48)
            .background(Color.purple.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 13))

            // Subscription Information
            VStack(alignment: .leading, spacing: 4) {

                Text(subscription.serviceName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subscription.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(subscription.status.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        subscription.status == .active
                        ? purple
                        : .secondary
                    )

                Text(
                    "Renews on \(subscription.nextRenewalDate.formatted(date: .abbreviated, time: .omitted))"
                )
                .font(.caption2)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 5)

            // Subscription Cost
            VStack(alignment: .trailing, spacing: 5) {

                Text(
                    subscription.cost,
                    format: .currency(code: "INR")
                )
                .font(.headline)
                .foregroundStyle(.primary)

                Text(subscription.billingCycle.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color.purple.opacity(0.045))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    SubscriptionListView(
        subscriptionViewModel: SubscriptionViewModel()
    )
}
