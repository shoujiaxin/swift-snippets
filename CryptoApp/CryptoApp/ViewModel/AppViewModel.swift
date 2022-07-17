//
//  AppViewModel.swift
//  CryptoApp
//
//  Created by Jiaxin Shou on 2022/7/17.
//

import Foundation

private let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&sparkline=true&price_change_percentage=24h")!

class AppViewModel: ObservableObject {
    @Published var coins: [CryptoModel]?

    @Published var currentCoin: CryptoModel?

    init() {
        Task {
            do {
                try await fetchCryptoData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    @MainActor
    func fetchCryptoData() async throws {
        let session = URLSession.shared
        let response = try await session.data(from: url)

        coins = try JSONDecoder().decode([CryptoModel].self, from: response.0)
        currentCoin = coins?.first
    }
}
