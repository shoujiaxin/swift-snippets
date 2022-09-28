//
//  CustomRefreshView.swift
//  PullToRefresh
//
//  Created by Jiaxin Shou on 2022/8/6.
//

import SwiftUI

struct CustomRefreshView<Content: View>: View {
    let showsIndicators: Bool

    let content: Content

    let onRefresh: () async -> Void

    @StateObject
    private var scrollDelegate: ScrollViewModel = .init()

    init(showsIndicators: Bool = false, @ViewBuilder content: () -> Content, onRefresh: @escaping () async -> Void) {
        self.showsIndicators = showsIndicators
        self.content = content()
        self.onRefresh = onRefresh
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 150 * scrollDelegate.progress)

                content
            }
            .offset(coordinateSpace: "SCROLL") { offset in
                scrollDelegate.contentOffset = offset

                if !scrollDelegate.isEligible {
                    var progress = offset / 150
                    progress = max(progress, 0)
                    progress = min(progress, 1)

                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }

                if scrollDelegate.isEligible, !scrollDelegate.isRefreshing {
                    scrollDelegate.isRefreshing = true
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .overlay(alignment: .top, content: {
            ZStack {
                Capsule()
                    .fill(.black)
            }
            .frame(width: 126, height: 37)
            .offset(y: 11)
            .frame(maxHeight: .infinity, alignment: .top)
            .overlay(alignment: .top) {
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                    context.addFilter(.blur(radius: 10))

                    context.drawLayer { ctx in
                        for index in [1, 2] {
                            if let resolvedView = context.resolveSymbol(id: index) {
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: 30))
                            }
                        }
                    }
                } symbols: {
                    canvasSymbol()
                        .tag(1)

                    canvasSymbol(isCircle: true)
                        .tag(2)
                }
                .allowsHitTesting(false)
            }
            .overlay(alignment: .top) {
                refreshView()
                    .offset(y: 11)
            }
            .ignoresSafeArea()
        })
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isEligible) { newValue in
            if newValue {
                Task {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await onRefresh()
                    withAnimation(.easeInOut(duration: 0.25)) {
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func refreshView() -> some View {
        let centerOffset = scrollDelegate.isEligible ? max(scrollDelegate.contentOffset, 95) : scrollDelegate.scrollOffset
        let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
        ZStack {
            Image(systemName: "arrow.down")
                .font(.callout.bold())
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                .opacity(scrollDelegate.isEligible ? 0 : 1)

            ProgressView()
                .tint(.white)
                .frame(width: 38, height: 38)
                .opacity(scrollDelegate.isEligible ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
        .opacity(scrollDelegate.progress)
        .offset(y: offset)
    }

    @ViewBuilder
    private func canvasSymbol(isCircle: Bool = false) -> some View {
        if isCircle {
            let centerOffset = scrollDelegate.isEligible ? max(scrollDelegate.contentOffset, 95) : scrollDelegate.scrollOffset
            let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
            let scale = scrollDelegate.progress / 1 * 0.21
            Circle()
                .fill(.black)
                .frame(width: 47, height: 47)
                .scaleEffect(0.79 + scale)
                .offset(y: offset)
        } else {
            Capsule()
                .fill(.black)
                .frame(width: 126, height: 37)
        }
    }
}

extension View {
    func offset(coordinateSpace: String, offset: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .named(coordinateSpace)).minY

                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        offset(value)
                    }
            }
        }
    }
}

struct OffsetKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRefreshView(showsIndicators: false) {
            VStack {
                Rectangle()
                    .fill(.red)
                    .frame(height: 200)

                Rectangle()
                    .fill(.yellow)
                    .frame(height: 200)
            }
        } onRefresh: {
//            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
}
