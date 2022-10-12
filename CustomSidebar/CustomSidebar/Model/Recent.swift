//
//  Recent.swift
//  CustomSidebar
//
//  Created by Jiaxin Shou on 2022/10/12.
//

import Foundation

// Recent transaction model
struct Recent: Identifiable {
    let id: UUID = .init()

    let title: String

    let price: String

    let image: String
}

let recents: [Recent] = [
    .init(title: "Transfer via Card number", price: "$1200", image: "creditcard"),
    .init(title: "Transfer Other Banks", price: "$120", image: "arrow.left.arrow.right"),
    .init(title: "Transfer Same Bank", price: "$1500", image: "building.columns"),
    .init(title: "Transfer via \nPayPal", price: "$800", image: "building.2.fill"),
]
