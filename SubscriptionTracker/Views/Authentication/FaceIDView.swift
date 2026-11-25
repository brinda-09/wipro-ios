
import SwiftUI

struct FaceIDView: View {

    @ObservedObject var authViewModel: AuthViewModel
    @State private var isScanning = false
    var body: some View {

        ZStack {

            // MARK: - Background Gradient

            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.92, blue: 1.0),
                    Color.white,
                    Color(red: 0.91, green: 0.90, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {

                Spacer()
                    .frame(height: 15)

                // MARK: - App Logo

                VStack(spacing: 10) {

                    Image("AppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 105, height: 105)

                    Text("SubTrack")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color(red: 0.20, green: 0.08, blue: 0.40))

                    Text("YOUR SUBSCRIPTIONS, SIMPLIFIED")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // MARK: - Face ID Icon

                ZStack {

                    Circle()
                        .fill(.white.opacity(0.65))
                        .frame(width: 190, height: 190)
                        .shadow(color: .purple.opacity(0.15), radius: 20)

                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.purple, .blue.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 5
                        )
                        .frame(width: 190, height: 190)

                    Image(systemName: "faceid")
                        .font(.system(size: 85))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .indigo],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .scaleEffect(isScanning ? 1.12 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.7)
                                .repeatForever(autoreverses: true),
                            value: isScanning
                        )
                }

                // MARK: - Welcome Message

                VStack(spacing: 12) {

                    Text("Welcome Back!")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color(red: 0.20, green: 0.08, blue: 0.40))

                    Text("Securely access your subscriptions")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 15)
                }

                // MARK: - Error Message

                if let error = authViewModel.errorMessage {

                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // MARK: - Authentication Button

                Button {
                    isScanning = true
                    authViewModel.checkAuthentication()
                } label: {

                    Label(
                        authViewModel.failedAttempts == 0
                            ? "Authenticate with Face ID"
                            : "Try Face ID Again",
                        systemImage: "faceid"
                    )
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        LinearGradient(
                            colors: [
                                .purple,
                                .indigo,
                                .blue
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .purple.opacity(0.25), radius: 10, y: 5)
                }
                .disabled(authViewModel.isAuthenticating)
                .padding(.horizontal, 10)

                Spacer()

                // MARK: - Privacy Message

                HStack(spacing: 10) {

                    Image(systemName: "lock.shield.fill")
                        .foregroundStyle(.purple)

                    Text("Your data stays private and secure.")
                        .font(.footnote)
                        .foregroundStyle(.purple)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 20)
                .background(.purple.opacity(0.08))
                .clipShape(Capsule())

                Spacer()
            }
            .padding(25)
        }
    }
}

#Preview {
    FaceIDView(
        authViewModel: AuthViewModel()
    )
}
