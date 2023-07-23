//
//  ScreenshotPreventView.swift
//  ScreenshotHide
//
//  Created by Jiaxin Shou on 2023/7/23.
//

import SwiftUI

struct ScreenshotPreventView<Content: View>: View {
    private let content: Content

    @State
    private var hostingController: UIHostingController<Content>?

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()

        let controller = UIHostingController(rootView: self.content)
        controller.view.backgroundColor = .clear
        controller.view.tag = 1009
        _hostingController = .init(wrappedValue: controller)
    }

    var body: some View {
        ScreenshotPreventHelper(hostingController: $hostingController)
            .overlay {
                GeometryReader { geometry in
                    let size = geometry.size
                    Color.clear
                        .preference(key: SizeKey.self, value: size)
                        .onPreferenceChange(SizeKey.self) { value in
                            hostingController?.view.frame = .init(origin: .zero, size: value)
                        }
                }
            }
    }
}

private struct ScreenshotPreventHelper<Content: View>: UIViewRepresentable {
    @Binding
    var hostingController: UIHostingController<Content>?

    func makeUIView(context _: Context) -> UIView {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        return textField.subviews.first ?? .init()
    }

    func updateUIView(_ uiView: UIView, context _: Context) {
        if !uiView.subviews.contains(where: { $0.tag == 1009 }), let hostingController {
            uiView.addSubview(hostingController.view)
        }
    }
}

private struct SizeKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

#Preview {
    ScreenshotPreventView {}
}
