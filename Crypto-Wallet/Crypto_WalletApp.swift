import SwiftUI

@main
struct CryptoWalletApp: App {
    @State private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                DashboardView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
