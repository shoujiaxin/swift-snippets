//
//  CustomRefreshView.swift
//  PullToRefresh
//
//  Created by Jiaxin Shou on 2022/8/6.
//

import SwiftUI

struct CustomRefreshView<Content: View>: View {
    let showsIndicators: Bool

    let lottieFileName: String

    let content: Content

    let onRefresh: () async -> Void

    @StateObject
    private var scrollDelegate: ScrollViewModel = .init()

    init(showsIndicators: Bool = false, lottieFileName: String = "Loading", @ViewBuilder content: () -> Content, onRefresh: @escaping () async -> Void) {
        self.showsIndicators = showsIndicators
        self.lottieFileName = lottieFileName
        self.content = content()
        self.onRefresh = onRefresh
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                ResizableLottieView(fileName: lottieFileName, isPlaying: $scrollDelegate.isRefreshing)
                    .scaleEffect(scrollDelegate.isEligible ? 1 : 0.001)
                    .animation(.easeInOut(duration: 0.2), value: scrollDelegate.isEligible)
                    .overlay {
                        VStack(spacing: 12) {
                            Image(systemName: "arrow.down")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                                .padding(8)
                                .background(.primary, in: Circle())

                            Text("Pull To Refresh")
                                .font(.caption.bold())
                                .foregroundColor(.primary)
                        }
                        .opacity(scrollDelegate.isEligible ? 0 : 1)
                        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
                    }
                    .frame(height: 150 * scrollDelegate.progress)
                    .opacity(scrollDelegate.progress)
                    .offset(y: scrollDelegate.isEligible ? -(scrollDelegate.contentOffset < 0 ? 0 : scrollDelegate.contentOffset) : -(scrollDelegate.scrollOffset < 0 ? 0 : scrollDelegate.scrollOffset))

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
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isEligible) { newValue in
            if newValue {
                Task {
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
        CustomRefreshView(showsIndicators: false, lottieFileName: "Loading") {
            Rectangle()
                .fill(.red)
                .frame(height: 200)
        } onRefresh: {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
}
