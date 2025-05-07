import SwiftUI
import Foundation

struct CurrencyCardView: View {
    let currency: CryptoCurrency

    var body: some View {
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
                Text("$\(currency.currentPrice, specifier: "%.2f")")
                    .bold()
                Text("\(currency.changePercentage, specifier: "%.2f")%")
                    .foregroundColor(currency.isUp ? .green : .red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
