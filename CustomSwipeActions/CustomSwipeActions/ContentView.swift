//
//  ContentView.swift
//  CustomSwipeActions
//
//  Created by Jiaxin Shou on 2023/11/20.
//

import SwiftUI

struct ContentView: View {
    @State
    private var colors: [Color] = [
        .black,
        .yellow,
        .purple,
        .brown,
    ]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ForEach(colors, id: \.self) { color in
                        SwipeAction(cornerRadius: 15, direction: .trailing) {
                            cardView(color: color)
                        } actions: {
                            Action(tint: .blue, icon: "star.fill") {
                                print("bookmark")
                            }

                            Action(tint: .red, icon: "trash.fill") {
                                withAnimation(.easeInOut) {
                                    colors.removeAll { $0 == color }
                                }
                            }
                        }
                    }
                }
                .padding(15)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Messages")
        }
    }

    private func cardView(color: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 80, height: 5)

                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 60, height: 5)
            }

            Spacer(minLength: 0)
        }
        .foregroundStyle(.white.opacity(0.4))
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(color.gradient)
    }
}

enum SwipeDirection {
    case leading
    case trailing

    var alignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader { geometry in
                    let size = geometry.size

                    Rectangle()
                        .offset(y: phase == .identity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}

struct SwipeAction<Content>: View where Content: View {
    var cornerRadius: CGFloat = 0

    var direction: SwipeDirection = .trailing

    @ViewBuilder
    var content: Content

    @ActionBuilder
    var actions: [Action]

    let viewID: UUID = .init()

    @State
    private var isEnabled: Bool = true

    @State
    private var scrollOffset: CGFloat = .zero

    @Environment(\.colorScheme)
    private var colorScheme

    private var filteredActions: [Action] {
        actions.filter { $0.isEnabled }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .rotationEffect(.degrees(direction == .leading ? -180 : 0))
                        .containerRelativeFrame(.horizontal)
                        .background(colorScheme == .dark ? .black : .white)
                        .background {
                            if let firstAction = filteredActions.first {
                                firstAction.tint
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader { geometry in
                                let minX = geometry.frame(in: .scrollView(axis: .horizontal)).minX

                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) { value in
                                        scrollOffset = value
                                    }
                            }
                        }

                    actionButtons {
                        withAnimation(.snappy) {
                            proxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = filteredActions.last {
                    lastAction.tint
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.degrees(direction == .leading ? 180 : 0))
        }
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }

    private func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX > 0 ? -minX : 0
    }

    private func actionButtons(resetPosition: @escaping () -> Void) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: 100 * CGFloat(filteredActions.count))
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    ForEach(filteredActions) { action in
                        Button {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25))
                                action.action()
                                try? await Task.sleep(for: .seconds(0.1))
                                isEnabled = true
                            }
                        } label: {
                            Image(systemName: action.icon)
                                .font(action.iconFont)
                                .foregroundStyle(action.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .background(action.tint)
                        .rotationEffect(.degrees(direction == .leading ? -180 : 0))
                    }
                }
            }
    }
}

struct Action: Identifiable {
    let id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> Void
}

@resultBuilder
enum ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        components
    }
}

#Preview {
    ContentView()
}
