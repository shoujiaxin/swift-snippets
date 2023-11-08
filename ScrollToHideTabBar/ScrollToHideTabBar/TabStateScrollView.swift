//
//  TabStateScrollView.swift
//  ScrollToHideTabBar
//
//  Created by Jiaxin Shou on 2023/11/8.
//

import SwiftUI

struct TabStateScrollView<Content>: View where Content: View {
    let axis: Axis.Set

    let showIndicator: Bool

    @Binding
    var tabState: Visibility

    let content: () -> Content

    init(axis: Axis.Set, showIndicator: Bool, tabState: Binding<Visibility>, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.showIndicator = showIndicator
        _tabState = tabState
        self.content = content
    }

    var body: some View {
        ScrollView(axis) {
            content()
        }
        .scrollIndicators(showIndicator ? .visible : .hidden)
        .background {
            CustomGesture(onChange: handleTabState)
        }
    }

    private func handleTabState(_ gesture: UIPanGestureRecognizer) {
        let velocityY = gesture.velocity(in: gesture.view).y

        if velocityY < 0 {
            if abs(velocityY) / 5 > 60 && tabState == .visible {
                tabState = .hidden
            }
        } else {
            if abs(velocityY) / 5 > 40 && tabState == .hidden {
                tabState = .visible
            }
        }
    }
}

private struct CustomGesture: UIViewRepresentable {
    typealias UIViewType = UIView

    private let gestureID: String = UUID().uuidString

    let onChange: (UIPanGestureRecognizer) -> Void

    func makeUIView(context _: Context) -> UIViewType {
        .init()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superview = uiView.superview?.superview,
               superview.gestureRecognizers?.contains(where: { $0.name == gestureID }) != true
            {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                gesture.delegate = context.coordinator
                gesture.name = gestureID
                superview.addGestureRecognizer(gesture)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        .init(onChange: onChange)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let onChange: (UIPanGestureRecognizer) -> Void

        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }

        @objc
        func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }

        func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
            true
        }
    }
}
