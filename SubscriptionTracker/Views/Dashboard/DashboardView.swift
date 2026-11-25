
import SwiftUI

struct DashboardView: View {

    @ObservedObject var subscriptionViewModel: SubscriptionViewModel
    @State private var showingSubscriptions = false

    private let purple = Color(red: 0.48, green: 0.16, blue: 0.95)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 13) {

                    // Welcome Section
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome to SubTrack!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(purple)

                        Text("Manage all your subscriptions in one place.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Monthly Spending Card
                    HStack(spacing: 15) {
                        Image(systemName: "wallet.pass.fill")
                            .font(.system(size: 27))
                            .foregroundStyle(purple)
                            .frame(width: 58, height: 58)
                            .background(.white.opacity(0.75))
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Monthly Spending")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(
                                subscriptionViewModel.monthlySpending,
                                format: .currency(code: "INR")
                            )
                            .font(.system(size: 27, weight: .bold))
                            .foregroundStyle(purple)
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .padding(.bottom, 16)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.08),
                                Color.pink.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // Subscription Count Cards
                    HStack(spacing: 14) {
                        countCard(
                            title: "Total",
                            count: subscriptionViewModel.totalSubscriptions,
                            icon: "list.bullet"
                        )

                        countCard(
                            title: "Active",
                            count: subscriptionViewModel.activeSubscriptionsCount,
                            icon: "checkmark.circle"
                        )
                    }

                    // Spending by Category
                    VStack(alignment: .leading, spacing: 16) {
                        sectionTitle("Spending by Category")

                        if subscriptionViewModel.monthlySpending > 0 {
                            ForEach(SubscriptionCategory.allCases) { category in
                                let amount = subscriptionViewModel.spending(for: category)

                                if amount > 0 {
                                    VStack(spacing: 7) {
                                        HStack {
                                            Text(category.rawValue)
                                                .font(.subheadline)

                                            Spacer()

                                            Text(
                                                amount,
                                                format: .currency(code: "INR")
                                            )
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        }

                                        ProgressView(
                                            value: amount / subscriptionViewModel.monthlySpending
                                        )
                                        .tint(purple)
                                    }
                                }
                            }
                        } else {
                            Text("Add active subscriptions to see your spending breakdown.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(16)
                    .background(Color.purple.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // Upcoming Renewals
                    VStack(alignment: .leading, spacing: 15) {
                        sectionTitle("Upcoming Renewals")

                        if subscriptionViewModel.upcomingSubscriptions.isEmpty {
                            Text("No upcoming renewals in the next 30 days.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(
                                Array(subscriptionViewModel.upcomingSubscriptions.enumerated()),
                                id: \.element.id
                            ) { index, subscription in

                                HStack(spacing: 12) {
                                    Group {
                                        if subscription.serviceName.lowercased().contains("spotify") {
                                            Image("Spotify")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(7)
                                        } else if subscription.serviceName.lowercased().contains("netflix") {
                                            Image("Netflix")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(7)
                                        } else if subscription.serviceName.lowercased().contains("gcp") {
                                            Image("GCP")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(7)
                                        } else {
                                            Image(systemName: "calendar")
                                                .font(.system(size: 19))
                                                .foregroundStyle(purple)
                                        }
                                    }
                                    .frame(width: 43, height: 43)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(subscription.serviceName)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)

                                        Text(
                                            "Renews on \(subscription.nextRenewalDate.formatted(date: .abbreviated, time: .omitted))"
                                        )
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text(
                                        subscription.cost,
                                        format: .currency(code: "INR")
                                    )
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                }

                                if index < subscriptionViewModel.upcomingSubscriptions.count - 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.purple.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // View Subscriptions Button
                    Button {
                        showingSubscriptions = true
                    } label: {
                        Label(
                            "View My Subscriptions",
                            systemImage: "creditcard"
                        )
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingSubscriptions) {
                SubscriptionListView(
                    subscriptionViewModel: subscriptionViewModel
                )
            }
        }
    }

    // Section Heading
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(purple)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Count Card
    private func countCard(
        title: String,
        count: Int,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(purple)

            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.purple.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    DashboardView(
        subscriptionViewModel: SubscriptionViewModel()
    )
}
