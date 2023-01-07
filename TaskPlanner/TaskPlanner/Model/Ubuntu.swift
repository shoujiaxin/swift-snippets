//
//  Ubuntu.swift
//  TaskPlanner
//
//  Created by Jiaxin Shou on 2023/1/7.
//

import SwiftUI

enum Ubuntu {
    case light

    case bold

    case medium

    case regular

    var weight: Font.Weight {
        switch self {
        case .light:
            return .light
        case .bold:
            return .bold
        case .medium:
            return .medium
        case .regular:
            return .regular
        }
    }
}

extension View {
    func ubuntu(_ size: CGFloat, _ weight: Ubuntu) -> some View {
        font(.custom("Ubuntu", size: size))
            .fontWeight(weight.weight)
    }
}
