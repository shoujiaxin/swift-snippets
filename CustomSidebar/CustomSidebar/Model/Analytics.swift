//
//  Analytics.swift
//  CustomSidebar
//
//  Created by Jiaxin Shou on 2022/10/13.
//

import Foundation

// Analytics model
struct Analytics: Identifiable {
    let id: UUID = .init()

    let spend: Double

    let weekday: String
}

let analytics: [Analytics] = [
    .init(spend: 500, weekday: "Mon"),
    .init(spend: 240, weekday: "Tue"),
    .init(spend: 350, weekday: "Wed"),
    .init(spend: 432, weekday: "Thu"),
    .init(spend: 695, weekday: "Fri"),
    .init(spend: 652, weekday: "Sat"),
    .init(spend: 920, weekday: "Sun"),
]
