//
//  RoundedCorner.swift
//  SplitFlapDisplay
//
//  Created by Jiaxin Shou on 2023/1/15.
//

import SwiftUI

struct RoundedCorner: Shape {
    let radius: CGFloat

    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        return .init(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
