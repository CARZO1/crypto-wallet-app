import SwiftUI

struct CryptoBlockView: View {
    let currency: CryptoCurrency

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: currency.logoURL ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 40, height: 40)
                case .success(let image):
                    image.resizable()
                case .failure:
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())


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
                    .font(.headline)
                Text("\(currency.changePercentage, specifier: "%.2f")%")
                    .font(.subheadline)
                    .foregroundColor(currency.isUp ? .green : .red)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
