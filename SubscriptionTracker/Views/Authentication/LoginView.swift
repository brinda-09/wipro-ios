
import SwiftUI

struct LoginView: View {

    // MARK: - ViewModel

    @ObservedObject var authViewModel: AuthViewModel

    // MARK: - Local State

    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    // MARK: - Body

    var body: some View {

        NavigationStack {

            VStack(spacing: 25) {

                Spacer()

                // MARK: - App Logo

                VStack(spacing: 12) {

                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 55))
                        .foregroundStyle(.blue)

                    Text("SubTrack")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Welcome Back!")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Sign in to manage your subscriptions")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // MARK: - Login Form

                VStack(spacing: 18) {

                    // Username

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Username")
                            .font(.headline)

                        TextField("Enter your username", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                    }

                    // Password

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Password")
                            .font(.headline)

                        HStack {

                            Group {
                                if isPasswordVisible {
                                    TextField(
                                        "Enter your password",
                                        text: $password
                                    )
                                } else {
                                    SecureField(
                                        "Enter your password",
                                        text: $password
                                    )
                                }
                            }

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(
                                    systemName: isPasswordVisible
                                    ? "eye.slash"
                                    : "eye"
                                )
                                .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                    }
                }

                // MARK: - Error Message

                if let error = authViewModel.errorMessage {

                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                // MARK: - Login Button

                Button {

                    authViewModel.login(
                        username: username,
                        password: password
                    )

                } label: {

                    Text("Login")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                }

                Spacer()

                Text("Your subscriptions, all in one place.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(25)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView(
        authViewModel: AuthViewModel()
    )
}
