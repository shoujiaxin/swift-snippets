//
//  CustomRefreshView.swift
//  PullToRefresh
//
//  Created by Jiaxin Shou on 2022/6/21.
//

import SwiftUI

struct CustomRefreshView<Content: View>: View {
    let showsIndicators: Bool

    let lottieFileName: String

    let content: Content

    let onRefresh: () async -> Void

    init(showsIndicators: Bool = false, lottieFileName: String = "Loading", @ViewBuilder content: () -> Content, onRefresh: @escaping () -> Void) {
        self.showsIndicators = showsIndicators
        self.lottieFileName = lottieFileName
        self.content = content()
        self.onRefresh = onRefresh
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            content
        }
    }
}

struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRefreshView(showsIndicators: false, lottieFileName: "Loading") {
            Rectangle()
                .fill(.red)
                .frame(height: 200)
        } onRefresh: {}
    }
}
