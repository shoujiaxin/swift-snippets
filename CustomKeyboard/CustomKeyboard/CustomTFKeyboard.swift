//
//  CustomTFKeyboard.swift
//  CustomKeyboard
//
//  Created by Jiaxin Shou on 2023/3/1.
//

import SwiftUI

extension TextField {
    @ViewBuilder
    func inputView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        background {
            SetTFKeyboard(keyboardContent: content())
        }
    }
}

private struct SetTFKeyboard<Content: View>: UIViewRepresentable {
    let keyboardContent: Content

    @State
    private var hostingController: UIHostingController<Content>?

    func makeUIView(context _: Context) -> UIView {
        .init()
    }

    func updateUIView(_ uiView: UIViewType, context _: Context) {
        DispatchQueue.main.async {
            if let textFieldContainerView = uiView.superview?.superview,
               let textField = textFieldContainerView.textField
            {
                if let hostingController {
                    hostingController.rootView = keyboardContent
                } else {
                    hostingController = UIHostingController(rootView: keyboardContent)
                    hostingController?.view.frame = .init(origin: .zero, size: hostingController?.view.intrinsicContentSize ?? .zero)
                    textField.inputView = hostingController?.view
                }
            } else {
                print("Failed to find TextField")
            }
        }
    }
}

private extension UIView {
    var allSubviews: [UIView] {
        subviews.flatMap { [$0] + $0.subviews }
    }

    var textField: UITextField? {
        if let textField = allSubviews.first(where: { $0 is UITextField }) as? UITextField {
            return textField
        }
        return nil
    }
}
