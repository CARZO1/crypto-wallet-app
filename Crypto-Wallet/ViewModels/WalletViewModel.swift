import Foundation

class WalletViewModel: ObservableObject {
    @Published var currencies: [CryptoCurrency] = []
    @Published var balance: Double = 100_000

    init() {
        loadData()
    }

    func loadData() {
        let coinGeckoIDs = ["bitcoin", "ethereum", "solana", "ripple", "binancecoin", "dogecoin", "cardano", "tether"]

        CryptoAPIService.shared.fetchPrices(for: coinGeckoIDs) { currencies in
            DispatchQueue.main.async {
                if currencies.isEmpty {
                    print("No currencies returned from CoinGecko.")
                } else {
                    print("Received \(currencies.count) currencies from API.")
                    currencies.forEach { print(" - \($0.name): \($0.currentPrice) AUD") }
                }

                self.currencies = currencies
                self.loadHoldings()
            }
        }
    }

    var portfolioValue: Double {
        currencies.reduce(0) { $0 + $1.valueHeld }
    }

    func buy(_ currency: CryptoCurrency, amountInDollars: Double) {
        guard amountInDollars <= balance else { return }

        if let index = currencies.firstIndex(where: { $0.id == currency.id }) {
            let price = currencies[index].currentPrice
            let amountToBuy = amountInDollars / price
            currencies[index].amountOwned += amountToBuy
            balance -= amountInDollars
            saveHoldings()
        }
    }

    func sell(_ currency: CryptoCurrency, amountInDollars: Double) {
        if let index = currencies.firstIndex(where: { $0.id == currency.id }) {
            let price = currencies[index].currentPrice
            let amountToSell = amountInDollars / price

            guard currencies[index].amountOwned >= amountToSell else { return }

            currencies[index].amountOwned -= amountToSell
            balance += amountInDollars
            saveHoldings()
        }
    }

    private func saveHoldings() {
        let holdings = currencies.map { [$0.symbol: $0.amountOwned] }
        UserDefaults.standard.set(holdings, forKey: "userHoldings")
    }
    
    private func loadHoldings() {
        if let saved = UserDefaults.standard.array(forKey: "userHoldings") as? [[String: Double]] {
            for holding in saved {
                for (symbol, amount) in holding {
                    if let index = currencies.firstIndex(where: { $0.symbol.uppercased() == symbol.uppercased() }) {
                        currencies[index].amountOwned = amount
                    }
                }
            }
        }
    }
}
