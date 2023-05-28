//
//  Highlight.swift
//  ShowcaseView
//
//  Created by Jiaxin Shou on 2023/5/28.
//

import SwiftUI

struct Highlight: Identifiable, Equatable {
    let id: UUID = .init()

    let anchor: Anchor<CGRect>

    let title: String

    let cornerRadius: CGFloat

    var style: RoundedCornerStyle = .continuous

    var scale: CGFloat = 1
}
