//
//  ContentView.swift
//  SwipeToHideNavBar
//
//  Created by Jiaxin Shou on 2023/11/26.
//

import SwiftUI

struct ContentView: View {
    @State
    private var hideNavBar: Bool = false

    var body: some View {
        NavigationStack {
            List(1 ... 50, id: \.self) { index in
                NavigationLink {
                    List(1 ... 50, id: \.self) { index in
                        Text("Item \(index)")
                    }
                    .navigationTitle("Subtitle")
                    .hideNavBarOnSwipe(false)
                } label: {
                    Text("List Item \(index)")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        hideNavBar.toggle()
                    } label: {
                        Image(systemName: hideNavBar ? "eye.slash" : "eye")
                    }
                }
            }
            .hideNavBarOnSwipe(hideNavBar)
        }
    }
}

extension View {
    func hideNavBarOnSwipe(_ isHidden: Bool) -> some View {
        modifier(NavBarModifier(isHidden: isHidden))
    }
}

private struct NavBarModifier: ViewModifier {
    let isHidden: Bool

    @State
    private var isNavBarHidden: Bool?

    func body(content: Content) -> some View {
        content
            .onChange(of: isHidden, initial: true) { _, newValue in
                isNavBarHidden = newValue
            }
            .onDisappear {
                isNavBarHidden = nil
            }
            .background(NavigationControllerExtractor(isHidden: isNavBarHidden))
    }
}

private struct NavigationControllerExtractor: UIViewRepresentable {
    typealias UIViewType = UIView

    let isHidden: Bool?

    func makeUIView(context _: Context) -> UIViewType {
        .init()
    }

    func updateUIView(_ uiView: UIViewType, context _: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let hostView = uiView.superview?.superview,
               let parentViewController = hostView.parentViewController,
               let isHidden
            {
                parentViewController.navigationController?.hidesBarsOnSwipe = isHidden
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

#Preview {
    ContentView()
}
