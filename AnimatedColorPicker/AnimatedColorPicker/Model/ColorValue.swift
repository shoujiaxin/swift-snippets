//
//  ColorValue.swift
//  AnimatedColorPicker
//
//  Created by Jiaxin Shou on 2023/1/8.
//

import SwiftUI

struct ColorValue: Identifiable, Hashable, Equatable {
    let id: UUID = .init()

    let colorCode: String

    let title: String

    var color: Color {
        .init(hex: .init(colorCode, radix: 16)!)
    }
}

extension Color {
    init(hex: UInt) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double((hex >> 0) & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

extension NSColor {
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let colorSpace = usingColorSpace(.extendedSRGB) ?? .init(red: 1, green: 1, blue: 1, alpha: 1)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        colorSpace.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue)
    }
}

let sampleColors: [ColorValue] = [
    .init(colorCode: "5F27CD", title: "Warm Purple"),
    .init(colorCode: "222F3E", title: "Imperial Black"),
    .init(colorCode: "E15F41", title: "Old Rose"),
    .init(colorCode: "786FA6", title: "Mountain View"),
    .init(colorCode: "EE5253", title: "Armor Red"),
    .init(colorCode: "05C46B", title: "Orc Skin"),
]
