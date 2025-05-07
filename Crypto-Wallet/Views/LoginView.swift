import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var showError = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Crypto Wallet Login")
                .font(.title)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if showError {
                Text("Invalid credentials")
                    .foregroundColor(.red)
            }

            Button("Login") {
                if email.isEmpty || password.isEmpty {
                    showError = true
                } else {
                    showError = false
                    isLoggedIn = true
                }
            }
            .padding()
        }
        .padding()
    }
}
