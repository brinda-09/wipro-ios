
import SwiftUI

struct ContentView: View {

    // Authentication
    @StateObject private var authViewModel = AuthViewModel()

    // Shared subscription data
    @StateObject private var subscriptionViewModel = SubscriptionViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                DashboardView(
                    subscriptionViewModel: subscriptionViewModel
                )
            } else if authViewModel.showLoginScreen {
                LoginView(authViewModel: authViewModel)
            } else {
                FaceIDView(authViewModel: authViewModel)
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
        .animation(.easeInOut, value: authViewModel.showLoginScreen)
        
    }
}

#Preview {
    ContentView()
}
