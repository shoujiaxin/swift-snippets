//
//  Album.swift
//  AnimatedStickyHeader
//
//  Created by Jiaxin Shou on 2023/1/9.
//

import Foundation

struct Album: Identifiable {
    let id: UUID = .init()

    let name: String
}

let albums: [Album] = [
    .init(name: "Key Ingredient"),
    .init(name: "Key Ingredient (Intrumental)"),
    .init(name: "To Kill a Living Book "),
    .init(name: "Millennium Mother"),
    .init(name: "Rightfully"),
    .init(name: "Hue"),
    .init(name: "Miracle Milk"),
    .init(name: "Mag Mell"),
]
