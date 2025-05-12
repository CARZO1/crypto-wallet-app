import SwiftUI

struct CoinDetailView: View {
    @ObservedObject var viewModel: WalletViewModel
    let currency: CryptoCurrency

    @State private var dollarAmount: String = ""
    @State private var showConfirmation = false
    @State private var transactionType: String = ""
    @State private var confirmedAmount: Double = 0

    var convertedAmount: Double {
        guard let aud = Double(dollarAmount), currency.currentPrice > 0 else { return 0 }
        return aud / currency.currentPrice
    }

    var body: some View {
        VStack(spacing: 20) {
            // logo
            AsyncImage(url: URL(string: currency.logoURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .padding(.top)

            Text(currency.name)
                .font(.largeTitle)

            Text("Price: $\(currency.currentPrice, specifier: "%.2f")")
            Text("You own: \(currency.amountOwned, specifier: "%.6f") \(currency.symbol)")
            Text("Current Value: $\(currency.valueHeld, specifier: "%.2f")")

            TextField("Enter AUD amount", text: $dollarAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            if let aud = Double(dollarAmount), aud > 0 {
                Text("$\(aud, specifier: "%.2f") AUD = \(convertedAmount, specifier: "%.6f") \(currency.symbol)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // buttons
            HStack {
                Button("Buy") {
                    if let amount = Double(dollarAmount) {
                        confirmedAmount = convertedAmount
                        viewModel.buy(currency, amountInDollars: amount)
                        transactionType = "Buy"
                        showConfirmation = true
                        dollarAmount = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(!canBuy)

                Button("Sell") {
                    if let amount = Double(dollarAmount) {
                        confirmedAmount = convertedAmount
                        viewModel.sell(currency, amountInDollars: amount)
                        transactionType = "Sell"
                        showConfirmation = true
                        dollarAmount = ""
                    }
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .disabled(!canSell)
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("\(transactionType) Successful"),
                message: Text("Your \(transactionType.lowercased()) of \(confirmedAmount, specifier: "%.6f") \(currency.symbol) was successful."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    var canBuy: Bool {
        if let amount = Double(dollarAmount) {
            return amount > 0 && amount <= viewModel.balance
        }
        return false
    }

    var canSell: Bool {
        if let amount = Double(dollarAmount) {
            let tokenAmount = amount / currency.currentPrice
            return tokenAmount <= currency.amountOwned && tokenAmount > 0
        }
        return false
    }
}
