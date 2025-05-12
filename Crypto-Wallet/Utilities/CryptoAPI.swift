import Foundation

class CryptoAPIService {
    static let shared = CryptoAPIService()

    func fetchPrices(for ids: [String], completion: @escaping ([CryptoCurrency]) -> Void) {
        let joinedIds = ids.joined(separator: ",")
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=aud&ids=\(joinedIds)"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion([])
                return
            }

            guard let data = data else {
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode([CoinMarketData].self, from: data)
                let currencies = decoded.map {
                    CryptoCurrency(
                        name: $0.name,
                        symbol: $0.symbol.uppercased(),
                        currentPrice: $0.current_price,
                        previousPrice: $0.current_price * 0.98,
                        logoURL: $0.image
                    )
                }
                completion(currencies)
            } catch {
                completion([])
            }
        }.resume()
    }
}

struct CoinMarketData: Decodable {
    let name: String
    let symbol: String
    let current_price: Double
    let image: String
}
