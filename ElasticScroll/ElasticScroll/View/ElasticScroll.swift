//
//  ElasticScroll.swift
//  ElasticScroll
//
//  Created by Jiaxin Shou on 2023/7/4.
//

import SwiftUI

extension View {
    func elasticScroll(scrollRect: CGRect, screenSize: CGSize) -> some View {
        modifier(ElasticScroll(scrollRect: scrollRect, screenSize: screenSize))
    }
}

private struct ElasticScroll: ViewModifier {
    let scrollRect: CGRect

    let screenSize: CGSize

    @State
    private var viewRect: CGRect = .zero

    func body(content: Content) -> some View {
        let progress = scrollRect.minY / scrollRect.maxY
        let elasticOffset = 1.2 * (progress * viewRect.minY)
        let bottomProgress = max(1 - scrollRect.maxY / screenSize.height, 0)
        let bottomElasticOffset = viewRect.maxY * bottomProgress
        content
            .offset(y: scrollRect.minY > 0 ? elasticOffset : 0)
            .offset(y: scrollRect.minY > 0 ? -(progress * scrollRect.minY) : 0)
            .offset(y: scrollRect.maxY < screenSize.height ? bottomElasticOffset : 0)
            .offsetExtractor(coordinateSpace: "ScrollView") { rect in
                viewRect = rect
            }
    }
}
