//
//  Home.swift
//  GooeyShareButton
//
//  Created by Jiaxin Shou on 2023/5/28.
//

import SwiftUI

struct Home: View {
    let size: CGSize

    @State
    private var isExpanded: Bool = false

    @State
    private var radius: CGFloat = 10

    @State
    private var animatedRadius: CGFloat = 10

    @State
    private var scale: CGFloat = 1

    @State
    private var baseOffset: [Bool] = .init(repeating: false, count: 5)

    @State
    private var secondaryOffset: [Bool] = .init(repeating: false, count: 2)

    @State
    private var showIcons: [Bool] = .init(repeating: false, count: 2)

    @State
    private var dispatchTask: DispatchWorkItem?

    var body: some View {
        VStack {
            let padding: CGFloat = 30
            let circleSize = (size.width - padding) / 5

            ZStack {
                ShapeMorphingView(systemImage: isExpanded ? "xmark.circle.fill" : "square.and.arrow.up.fill",
                                  fontSize: isExpanded ? circleSize * 0.9 : 35,
                                  color: .white)
                    .scaleEffect(isExpanded ? 0.6 : 1)
                    .background {
                        Rectangle()
                            .fill(.gray.gradient)
                            .mask {
                                Canvas { context, size in
                                    context.addFilter(.alphaThreshold(min: 0.5))
                                    context.addFilter(.blur(radius: animatedRadius))

                                    context.drawLayer { context1 in
                                        for index in 0 ... 4 {
                                            if let resolvedShareButton = context.resolveSymbol(id: index) {
                                                context1.draw(resolvedShareButton, at: .init(x: size.width / 2, y: size.height / 2))
                                            }
                                        }
                                    }
                                } symbols: {
                                    groupedShareButtons(size: circleSize, fillColor: true)
                                }
                            }
                    }

                groupedShareButtons(size: circleSize, fillColor: false)
            }
            .frame(height: circleSize)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: isExpanded) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                    showIcons[0] = true
                }
                withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                    showIcons[1] = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.15)) {
                    showIcons[0] = false
                    showIcons[1] = false
                }
            }
        }
    }

    private func groupedShareButtons(size: CGFloat, fillColor: Bool = true) -> some View {
        Group {
            shareButton(size: size, tag: 0, icon: "twitter", showIcon: showIcons[1]) {
                (baseOffset[0] ? -size : 0) + (secondaryOffset[0] ? -size : 0)
            }

            shareButton(size: size, tag: 1, icon: "facebook", showIcon: showIcons[0]) {
                baseOffset[1] ? -size : 0
            }

            shareButton(size: size, tag: 2, icon: "", showIcon: false) {
                0
            }
            .zIndex(100)
            .onTapGesture(perform: toggleShareButton)

            shareButton(size: size, tag: 3, icon: "tiktok", showIcon: showIcons[0]) {
                baseOffset[3] ? size : 0
            }

            shareButton(size: size, tag: 4, icon: "telegram", showIcon: showIcons[1]) {
                (baseOffset[4] ? size : 0) + (secondaryOffset[1] ? size : 0)
            }
        }
        .foregroundColor(fillColor ? .black : .clear)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animationProgress(endValue: radius) { value in
            animatedRadius = value

            if value >= 15 {
                withAnimation(.easeInOut(duration: 0.4)) {
                    radius = 10
                }
            }
        }
    }

    private func shareButton(size: CGFloat, tag: Int, icon: String, showIcon: Bool, offset: @escaping () -> CGFloat) -> some View {
        Circle()
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .overlay {
                if !icon.isEmpty {
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: size * 0.4)
                        .opacity(showIcon ? 1 : 0)
                        .scaleEffect(showIcon ? 1 : 0.001)
                }
            }
            .contentShape(Circle())
            .offset(x: offset())
            .tag(tag)
    }

    private func toggleShareButton() {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.4)) {
            isExpanded.toggle()
            scale = isExpanded ? 0.75 : 1
        }

        withAnimation(.easeInOut(duration: 0.4)) {
            radius = 20
        }

        for index in baseOffset.indices {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.8)) {
                baseOffset[index].toggle()
            }
        }

        if let dispatchTask {
            dispatchTask.cancel()
        }

        dispatchTask = .init(block: {
            for index in secondaryOffset.indices {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.8)) {
                    secondaryOffset[index].toggle()
                }
            }
        })

        if let dispatchTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + (isExpanded ? 0.15 : 0), execute: dispatchTask)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
