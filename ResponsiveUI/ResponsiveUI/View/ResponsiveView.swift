//
//  ResponsiveView.swift
//  ResponsiveUI
//
//  Created by Jiaxin Shou on 2022/12/18.
//

import SwiftUI

struct ResponsiveView<Content: View>: View {
    let content: (Properties) -> Content

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isLandscape = size.width > size.height
            let isiPad = UIDevice.current.userInterfaceIdiom == .pad

            content(.init(isLandscape: isLandscape, isiPad: isiPad, isSplit: isSplit, size: size))
                .frame(width: size.width, height: size.height, alignment: .center)
                .onAppear {
                    updateFraction(fraction: isLandscape && !isSplit ? 0.3 : 0.5)
                }
                .onChange(of: isSplit) { newValue in
                    updateFraction(fraction: isLandscape && !newValue ? 0.3 : 0.5)
                }
                .onChange(of: isLandscape) { newValue in
                    updateFraction(fraction: newValue && !isSplit ? 0.3 : 0.5)
                }
        }
    }

    private var isSplit: Bool {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return false
        }
        return screen.windows.first?.frame.size != UIScreen.main.bounds.size
    }

    private func updateFraction(fraction: Double) {
        NotificationCenter.default.post(name: .init("UpdateFraction"), object: nil, userInfo: [
            "fraction": fraction,
        ])
    }
}

struct Properties {
    let isLandscape: Bool

    let isiPad: Bool

    let isSplit: Bool

    let size: CGSize
}

struct ResponsiveView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveView { prop in
            VStack(spacing: 20) {
                Text("isLandscape: \(prop.isLandscape.description)")

                Text("isiPad: \(prop.isiPad.description)")

                Text("size: \(prop.size.debugDescription)")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}
