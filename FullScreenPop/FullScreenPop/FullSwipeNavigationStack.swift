//
//  FullSwipeNavigationStack.swift
//  FullScreenPop
//
//  Created by Jiaxin Shou on 2023/11/26.
//

import SwiftUI

struct FullSwipeNavigationStack<Content>: View where Content: View {
    let content: () -> Content

    @State
    private var customGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.isEnabled = false
        return gesture
    }()

    var body: some View {
        NavigationStack {
            content()
                .background {
                    AttachGestureView(gesture: $customGesture)
                }
        }
        .environment(\.popGestureID, customGesture.name)
        .onReceive(NotificationCenter.default.publisher(for: .init(customGesture.name ?? ""))) { notification in
            if let userInfo = notification.userInfo,
               let status = userInfo["status"] as? Bool
            {
                customGesture.isEnabled = status
            }
        }
    }
}

private struct FullSwipeModifier: ViewModifier {
    let isEnabled: Bool

    @Environment(\.popGestureID)
    private var popGestureID

    func body(content: Content) -> some View {
        content
            .onChange(of: isEnabled, initial: true) { _, newValue in
                guard let popGestureID else {
                    return
                }
                NotificationCenter.default.post(name: .init(popGestureID),
                                                object: nil,
                                                userInfo: [
                                                    "status": newValue,
                                                ])
            }
            .onDisappear {
                guard let popGestureID else {
                    return
                }
                NotificationCenter.default.post(name: .init(popGestureID),
                                                object: nil,
                                                userInfo: [
                                                    "status": false,
                                                ])
            }
    }
}

private struct PopNotificationID: EnvironmentKey {
    static var defaultValue: String?
}

private extension EnvironmentValues {
    var popGestureID: String? {
        get {
            self[PopNotificationID.self]
        }
        set {
            self[PopNotificationID.self] = newValue
        }
    }
}

extension View {
    func enableFullSwipePop(_ isEnabled: Bool) -> some View {
        modifier(FullSwipeModifier(isEnabled: isEnabled))
    }
}

private struct AttachGestureView: UIViewRepresentable {
    typealias UIViewType = UIView

    @Binding var gesture: UIPanGestureRecognizer

    func makeUIView(context _: Context) -> UIViewType {
        .init()
    }

    func updateUIView(_ uiView: UIViewType, context _: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            if let parentViewController = uiView.parentViewController,
               let navigationController = parentViewController.navigationController
            {
                if let _ = navigationController.view.gestureRecognizers?.first(where: { $0.name == gesture.name }) {
                    print("Already attached")
                } else {
                    navigationController.addFullSwipeGesture(gesture)
                    print("Attached")
                }
            }
        }
    }
}

private extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) { $0.next }
            .first { $0 is UIViewController } as? UIViewController
    }
}

private extension UINavigationController {
    func addFullSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        guard let interactivePopGestureRecognizer,
              let targets = interactivePopGestureRecognizer.value(forKey: "targets")
        else {
            return
        }

        gesture.setValue(targets, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
}
