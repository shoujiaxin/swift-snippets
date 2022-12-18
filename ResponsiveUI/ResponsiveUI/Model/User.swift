//
//  User.swift
//  ResponsiveUI
//
//  Created by Jiaxin Shou on 2022/12/18.
//

import Foundation

struct User: Identifiable {
    let id: UUID = .init()

    let name: String

    let image: String

    let title: String
}

let users: [User] = [
    .init(name: "iJustine", image: "User1", title: "Apple Event is here"),
    .init(name: "Jenna", image: "User2", title: "Xbox Gaming"),
    .init(name: "Jesscia", image: "User3", title: "New iPhone 14 Design"),
    .init(name: "Rebecca", image: "User4", title: "MacBook with Multiple Colors"),
]
