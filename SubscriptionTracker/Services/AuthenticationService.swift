
import Foundation
import LocalAuthentication

enum BiometricAuthenticationResult {
    case success
    case unavailable
    case failed(String)
}

final class AuthenticationService {

    func authenticate(
        completion: @escaping (BiometricAuthenticationResult) -> Void
    ) {

        let context = LAContext()
        var error: NSError?

        // Check whether Face ID is available
        let canUseBiometrics = context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )

        // Check specifically for Face ID
        guard canUseBiometrics,
              context.biometryType == .faceID else {

            completion(.unavailable)
            return
        }

        // Request Face ID authentication
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate to access your subscriptions"
        ) { success, authenticationError in

            DispatchQueue.main.async {

                if success {
                    completion(.success)
                } else {
                    completion(
                        .failed(
                            authenticationError?.localizedDescription
                            ?? "Authentication failed."
                        )
                    )
                }
            }
        }
    }
}

