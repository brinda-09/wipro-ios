
import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Properties

    @Published var isAuthenticated = false
    @Published var showLoginScreen = false
    @Published var errorMessage: String?
    @Published private(set) var failedAttempts = 0
    @Published private(set) var isAuthenticating = false

    private let authenticationService = AuthenticationService()

    private let maximumAttempts = 3

    // MARK: - Face ID Authentication

    func checkAuthentication() {

        guard !isAuthenticating,
              !isAuthenticated,
              !showLoginScreen else {
            return
        }

        isAuthenticating = true
        errorMessage = nil

        authenticationService.authenticate { [weak self] result in

            guard let self = self else { return }

            self.isAuthenticating = false

            switch result {

            case .success:
                self.failedAttempts = 0
                self.isAuthenticated = true
                self.showLoginScreen = false
                self.errorMessage = nil

            case .unavailable:
                self.showLoginScreen = true
                self.errorMessage = "Face ID is unavailable. Please log in."

            case .failed(let message):

                self.failedAttempts += 1

                if self.failedAttempts >= self.maximumAttempts {

                    self.showLoginScreen = true
                    self.errorMessage =
                        "Face ID failed 3 times. Please log in."

                } else {

                    self.errorMessage =
                        "\(message) Please try Face ID again. " +
                        "\(self.maximumAttempts - self.failedAttempts) attempts remaining."
                }
            }
        }
    }

    // MARK: - Local Login

    func login(username: String, password: String) {

        guard !username.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            errorMessage = "Please enter your username."
            return
        }

        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }

        // Temporary demo credentials

        if username == "admin" && password == "123456" {

            isAuthenticated = true
            showLoginScreen = false
            errorMessage = nil
            failedAttempts = 0

        } else {

            errorMessage = "Invalid username or password."
        }
    }

    // MARK: - Logout

    func logout() {

        isAuthenticated = false
        showLoginScreen = false
        errorMessage = nil
        failedAttempts = 0
    }
}
