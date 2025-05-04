import Foundation

struct CryptoCurrency: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let currentPrice: Double
    let previousPrice: Double

    var changePercentage: Double {
        ((currentPrice - previousPrice) / previousPrice) * 100
    }

    var isUp: Bool {
        currentPrice >= previousPrice
    }
}
