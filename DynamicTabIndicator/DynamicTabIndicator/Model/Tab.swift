//
//  Tab.swift
//  DynamicTabIndicator
//
//  Created by Jiaxin Shou on 2022/7/15.
//

import Foundation

struct Tab: Identifiable, Hashable {
    let id = UUID()

    let name: String

    let imageName: String
}

let sampleTabs: [Tab] = [
    .init(name: "Color", imageName: "Image1"),
    .init(name: "Smile", imageName: "Image2"),
    .init(name: "Wave", imageName: "Image3"),
]
