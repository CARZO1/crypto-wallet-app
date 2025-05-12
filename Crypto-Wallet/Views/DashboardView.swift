import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel = WalletViewModel()
    @State private var showDeposit = false

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Funds")
                            .font(.caption)
                        Text("$\(viewModel.balance, specifier: "%.2f")")
                            .font(.title2)
                            .bold()
                    }

                    Spacer()

                    NavigationLink(destination: PortfolioDetailView(currencies: viewModel.currencies)) {
                        VStack(alignment: .trailing) {
                            Text("Portfolio")
                                .font(.caption)
                            Text("$\(viewModel.portfolioValue, specifier: "%.2f")")
                                .font(.title2)
                                .bold()
                        }
                        .foregroundColor(.primary)
                    }
                }
                .padding([.horizontal, .top])

                List(viewModel.currencies) { currency in
                    NavigationLink(destination: CoinDetailView(viewModel: viewModel, currency: currency)) {
                        CryptoBlockView(currency: currency)
                    }
                }
            }
            .navigationTitle("My Wallet")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDeposit = true
                    }) {
                        Text("Deposit")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                viewModel.loadData()
            }
            .sheet(isPresented: $showDeposit) {
                DepositView(viewModel: viewModel)
            }
        }
    }
}

