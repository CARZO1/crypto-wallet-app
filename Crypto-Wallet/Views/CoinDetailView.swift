import SwiftUI

struct CurrencyDetailView: View {
    @ObservedObject var viewModel: WalletViewModel
    let currency: CryptoCurrency

    @State private var dollarAmount: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text(currency.name)
                .font(.largeTitle)

            Text("Price: $\(currency.currentPrice, specifier: "%.2f")")
            Text("You own: \(currency.amountOwned, specifier: "%.6f") \(currency.symbol)")
            Text("Current value: $\(currency.valueHeld, specifier: "%.2f")")

            TextField("Amount in USD", text: $dollarAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("Buy") {
                    if let amount = Double(dollarAmount) {
                        viewModel.buy(currency, amountInDollars: amount)
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Sell") {
                    if let amount = Double(dollarAmount) {
                        viewModel.sell(currency, amountInDollars: amount)
                    }
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding()
    }
}
