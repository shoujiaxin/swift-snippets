//
//  HLine.swift
//  TaskPlanner
//
//  Created by Jiaxin Shou on 2023/1/8.
//

import SwiftUI

struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: 0, y: rect.height / 2))
        path.addLine(to: .init(x: rect.width, y: rect.height / 2))
        return path
    }
}
