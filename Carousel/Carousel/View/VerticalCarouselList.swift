//
//  VerticalCarouselList.swift
//  Carousel
//
//  Created by Jiaxin Shou on 2022/7/12.
//

import SwiftUI

struct VerticalCarouselList<Content: View>: UIViewRepresentable {
    typealias UIViewType = UIScrollView

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context _: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        setup(scrollView)
        return scrollView
    }

    func updateUIView(_: UIScrollView, context _: Context) {}

    func setup(_ view: UIScrollView) {
        let hostingVC = UIHostingController(rootView: content)
        hostingVC.view.backgroundColor = .clear
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostingVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            hostingVC.view.widthAnchor.constraint(equalTo: view.widthAnchor),
        ]

        view.addSubview(hostingVC.view)
        view.addConstraints(constraints)

        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
    }
}
