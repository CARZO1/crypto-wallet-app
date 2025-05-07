import Foundation

class WalletViewModel: ObservableObject {
    @Published var currencies: [CryptoCurrency] = []
    @Published var balance: Double = 100_000

    func buy(_ currency: CryptoCurrency, amountInDollars: Double) {
        guard amountInDollars <= balance else { return }

        if let index = currencies.firstIndex(where: { $0.id == currency.id }) {
            let price = currencies[index].currentPrice
            let amountToBuy = amountInDollars / price
            currencies[index].amountOwned += amountToBuy
            balance -= amountInDollars
        }
    }

    func sell(_ currency: CryptoCurrency, amountInDollars: Double) {
        if let index = currencies.firstIndex(where: { $0.id == currency.id }) {
            let price = currencies[index].currentPrice
            let amountToSell = amountInDollars / price

            guard currencies[index].amountOwned >= amountToSell else { return }

            currencies[index].amountOwned -= amountToSell
            balance += amountInDollars
        }
    }
    
    init() {
        loadData()
    }

    func loadData() {
        CryptoAPIService.shared.fetchPrices(for: ["bitcoin", "ethereum", "solana", "ripple", "binancecoin", "dogecoin", "cardano", "tether"]) { prices in
            DispatchQueue.main.async {
                self.currencies = [
                    CryptoCurrency(name: "Bitcoin", symbol: "BTC", currentPrice: prices["bitcoin"] ?? 0, previousPrice: (prices["bitcoin"] ?? 0) * 0.98),
                    CryptoCurrency(name: "Ethereum", symbol: "ETH", currentPrice: prices["ethereum"] ?? 0, previousPrice: (prices["ethereum"] ?? 0) * 0.98),
                    CryptoCurrency(name: "Solana", symbol: "SOL", currentPrice: prices["solana"] ?? 0, previousPrice: (prices["solana"] ?? 0) * 0.98),
                    CryptoCurrency(name: "XRP", symbol: "XRP", currentPrice: prices["ripple"] ?? 0, previousPrice: (prices["ripple"] ?? 0) * 0.98),
                    CryptoCurrency(name: "BNB", symbol: "BNB", currentPrice: prices["binancecoin"] ?? 0, previousPrice: (prices["binancecoin"] ?? 0) * 0.98),
                    CryptoCurrency(name: "Dogecoin", symbol: "DOGE", currentPrice: prices["dogecoin"] ?? 0, previousPrice: (prices["dogecoin"] ?? 0) * 0.98),
                    CryptoCurrency(name: "Cardano", symbol: "ADA", currentPrice: prices["cardano"] ?? 0, previousPrice: (prices["cardano"] ?? 0) * 0.98),
                    CryptoCurrency(name: "Tether", symbol: "USDT", currentPrice: prices["tether"] ?? 0, previousPrice: (prices["tether"] ?? 0) * 0.98)
                ]
            }
        }
    }
}
