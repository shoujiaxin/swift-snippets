//
//  OffsetHelper.swift
//  ElasticScroll
//
//  Created by Jiaxin Shou on 2023/7/4.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static let defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func offsetExtractor(coordinateSpace: String, completion: @escaping (CGRect) -> Void) -> some View {
        overlay {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named(coordinateSpace))
                Color.clear
                    .preference(key: OffsetKey.self, value: rect)
                    .onPreferenceChange(OffsetKey.self, perform: completion)
            }
        }
    }
}
