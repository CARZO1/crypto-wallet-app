import Foundation

class CryptoAPIService {
    static let shared = CryptoAPIService()

    func fetchPrices(for ids: [String], completion: @escaping ([String: Double]) -> Void) {
        let joinedIds = ids.joined(separator: ",")
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(joinedIds)&vs_currencies=usd"

        guard let url = URL(string: urlString) else {
            completion([:])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([:])
                return
            }

            do {
                let result = try JSONDecoder().decode([String: [String: Double]].self, from: data)
                var prices: [String: Double] = [:]
                for (key, value) in result {
                    prices[key] = value["usd"]
                }
                    completion(prices)
            } catch {
                completion([:])
            }
        }.resume()
    }
}
