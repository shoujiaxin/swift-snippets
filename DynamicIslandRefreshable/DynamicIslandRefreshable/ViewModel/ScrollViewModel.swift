//
//  ScrollViewModel.swift
//  PullToRefresh
//
//  Created by Jiaxin Shou on 2022/8/6.
//

import UIKit

final class ScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    @Published
    var isEligible: Bool = false

    @Published
    var isRefreshing: Bool = false

    @Published
    var scrollOffset: CGFloat = 0

    @Published
    var contentOffset: CGFloat = 0

    @Published
    var progress: CGFloat = 0

    private var rootController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = screen.windows.first?.rootViewController
        else {
            return .init()
        }
        return root
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        true
    }

    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGesture(gesture:)))
        panGesture.delegate = self

        rootController.view.addGestureRecognizer(panGesture)
    }

    func removeGesture() {
        rootController.view.gestureRecognizers?.removeAll()
    }

    @objc
    private func onGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .cancelled, .ended:
            print("User Released Touch")
            // 150 is the max duration
            if !isRefreshing {
                isEligible = scrollOffset > 150
            }
        default:
            return
        }
    }
}
