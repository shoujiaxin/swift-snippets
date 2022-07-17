//
//  CryptoModel.swift
//  CryptoApp
//
//  Created by Jiaxin Shou on 2022/7/17.
//

import Foundation

struct CryptoModel: Identifiable, Codable {
    let id: String

    let symbol: String

    let name: String

    let image: String

    let currentPrice: Double

    let lastUpdated: String

    let priceChange: Double

    let last7DaysPrice: [GraphModel]

    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case lastUpdated = "last_update"
        case priceChange = "price_change_percentage_24h"
        case last7DaysPrice = "sparkline_in_7d"
    }
}

struct GraphModel: Codable {
    let price: [Double]
}
