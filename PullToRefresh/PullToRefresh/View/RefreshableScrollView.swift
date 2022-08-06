//
//  RefreshableScrollView.swift
//  PullToRefresh
//
//  Created by Jiaxin Shou on 2022/6/22.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    typealias UIViewType = UIScrollView

    private let content: Content

    private let onRefresh: (UIRefreshControl) -> Void

    private let refreshControl: UIRefreshControl = .init()

    init(@ViewBuilder content: () -> Content, onRefresh: @escaping (UIRefreshControl) -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }

    func makeUIView(context: Context) -> UIViewType {
        let scrollView = UIScrollView()
        scrollView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(context.coordinator,
                                 action: #selector(context.coordinator.onRefresh),
                                 for: .valueChanged)

        setupContent(in: scrollView)

        return scrollView
    }

    func updateUIView(_ uiView: UIViewType, context _: Context) {
        uiView.subviews.last?.removeFromSuperview()
        setupContent(in: uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    private func setupContent(in parentView: UIViewType) {
        let hostingVC = UIHostingController(rootView: content.frame(maxHeight: .infinity, alignment: .top))
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            hostingVC.view.topAnchor.constraint(equalTo: parentView.topAnchor),
            hostingVC.view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            hostingVC.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            hostingVC.view.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            hostingVC.view.heightAnchor.constraint(greaterThanOrEqualTo: parentView.heightAnchor, constant: 1),
        ]

        parentView.addSubview(hostingVC.view)
        parentView.addConstraints(constraints)
    }

    class Coordinator: NSObject {
        let parent: RefreshableScrollView

        init(parent: RefreshableScrollView) {
            self.parent = parent
        }

        @objc func onRefresh() {
            parent.onRefresh(parent.refreshControl)
        }
    }
}

struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                ForEach(1 ... 5, id: \.self) { index in
                    Color.accentColor
                        .opacity(0.8)
                        .frame(height: 180)
                        .overlay {
                            Text("\(index)")
                                .font(.largeTitle)
                        }
                }
            }
            .padding()
        } onRefresh: { _ in
        }
    }
}
