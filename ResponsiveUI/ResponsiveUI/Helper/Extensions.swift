//
//  Extensions.swift
//  ResponsiveUI
//
//  Created by Jiaxin Shou on 2022/12/19.
//

import UIKit

extension UISplitViewController {
    override open func viewDidLoad() {
        preferredDisplayMode = .twoOverSecondary
        preferredSplitBehavior = .displace

        preferredPrimaryColumnWidthFraction = 0.3

        NotificationCenter.default.addObserver(self, selector: #selector(updateView(notification:)), name: .init("UpdateFraction"), object: nil)
    }

    @objc
    private func updateView(notification: Notification) {
        if let info = notification.userInfo, let fraction = info["fraction"] as? Double {
            preferredPrimaryColumnWidthFraction = fraction
        }
    }
}
