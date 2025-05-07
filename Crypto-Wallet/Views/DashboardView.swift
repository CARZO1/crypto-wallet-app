import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel = WalletViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Balance: $\(viewModel.balance, specifier: "%.2f")")
                    .font(.headline)
                    .padding(.top)

                List(viewModel.currencies) { currency in
                    NavigationLink(destination: CurrencyDetailView(viewModel: viewModel, currency: currency)) {
                        CurrencyCardView(currency: currency)
                    }
                }
            }
            .navigationTitle("My Wallet")
        }
    }
}
