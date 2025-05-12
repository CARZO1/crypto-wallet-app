import SwiftUI
import Charts

struct PortfolioDetailView: View {
    let currencies: [CryptoCurrency]

    var ownedCurrencies: [CryptoCurrency] {
        currencies.filter { $0.amountOwned > 0 }
    }
    
    private func portfolioPercentage(of currency: CryptoCurrency) -> Double {
        let total = ownedCurrencies.reduce(0) { $0 + $1.valueHeld }
        guard total > 0 else { return 0 }
        return (currency.valueHeld / total) * 100
    }

    var body: some View {
        VStack {
            Text("Portfolio Breakdown")
                .font(.title)
                .padding()

            if ownedCurrencies.isEmpty {
                Text("You don't own any crypto yet.")
                    .foregroundColor(.gray)
            } else {
                Chart(ownedCurrencies, id: \.symbol) { currency in
                    SectorMark(
                        angle: .value("Value", currency.valueHeld),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(by: .value("Symbol", currency.symbol))
                    .annotation(position: .overlay) {
                        Text("\(portfolioPercentage(of: currency), specifier: "%.1f")%")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }
                .frame(height: 250)
                .padding()

                List(ownedCurrencies, id: \.symbol) { currency in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(currency.name)
                                .font(.headline)
                            Text(currency.symbol)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(currency.amountOwned, specifier: "%.6f")")
                            Text("$\(currency.valueHeld, specifier: "%.2f")")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Portfolio")
    }
}
