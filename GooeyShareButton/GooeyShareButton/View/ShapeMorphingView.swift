//
//  ShapeMorphingView.swift
//  GooeyShareButton
//
//  Created by Jiaxin Shou on 2023/5/28.
//

import SwiftUI

struct ShapeMorphingView: View {
    let systemImage: String

    let fontSize: CGFloat

    var color: Color = .white

    let duration: CGFloat = 0.5

    @State
    private var newImage: String = ""

    @State
    private var radius: CGFloat = 0

    @State
    private var animatedRadiusValue: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            Canvas { context, size in
                context.addFilter(.alphaThreshold(min: 0.5, color: color))
                context.addFilter(.blur(radius: animatedRadiusValue))

                context.drawLayer { context1 in
                    if let resolvedImageView = context.resolveSymbol(id: 0) {
                        context1.draw(resolvedImageView, at: .init(x: size.width / 2, y: size.height / 2))
                    }
                }
            } symbols: {
                imageView(size: size)
                    .tag(0)
            }
        }
        .onAppear {
            if newImage.isEmpty {
                newImage = systemImage
            }
        }
        .onChange(of: systemImage) { newValue in
            newImage = newValue
            withAnimation(.linear(duration: duration).speed(2)) {
                radius = 12
            }
        }
        .animationProgress(endValue: radius) { value in
            animatedRadiusValue = value

            if value >= 6 {
                withAnimation(.linear(duration: duration).speed(2)) {
                    radius = 0
                }
            }
        }
    }

    @ViewBuilder
    private func imageView(size: CGSize) -> some View {
        if !newImage.isEmpty {
            Image(systemName: newImage)
                .font(.system(size: fontSize))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.9), value: newImage)
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.9), value: fontSize)
                .frame(width: size.width, height: size.height)
        }
    }
}

struct ShapeMorphingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
