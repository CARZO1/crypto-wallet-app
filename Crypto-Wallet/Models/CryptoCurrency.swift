import Foundation

struct CryptoCurrency: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let currentPrice: Double
    let previousPrice: Double
    var amountOwned: Double = 0
    var logoURL: String? = nil

    var changePercentage: Double {
        ((currentPrice - previousPrice) / previousPrice) * 100
    }

    var isUp: Bool {
        currentPrice >= previousPrice
    }
    
    var valueHeld: Double {
        amountOwned * currentPrice
    }
}
