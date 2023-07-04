//
//  ContentView.swift
//  Keyframes
//
//  Created by Jiaxin Shou on 2023/7/4.
//

import SwiftUI

struct ContentView: View {
    @State
    private var isAnimating: Bool = false

    var body: some View {
        VStack {
            Spacer()

            Image(.icon)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 180)
                .keyframeAnimator(initialValue: Keyframe(), trigger: isAnimating) { view, frame in
                    view
                        .scaleEffect(frame.scale)
                        .offset(y: frame.offsetY)
                        .rotationEffect(frame.rotation, anchor: .bottom)
                        .background {
                            view
                                .blur(radius: 3.0)
                                .rotation3DEffect(
                                    .degrees(180),
                                    axis: (x: 1.0, y: 0.0, z: 0.0)
                                )
                                .mask {
                                    LinearGradient(colors:
                                        [
                                            .white.opacity(frame.reflectionOpacity),
                                            .white.opacity(frame.reflectionOpacity - 0.3),
                                            .white.opacity(frame.reflectionOpacity - 0.45),
                                            .clear,
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom)
                                }
                                .offset(y: 180)
                        }
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        CubicKeyframe(0.9, duration: 0.15)
                        CubicKeyframe(1.2, duration: 0.6)
                        CubicKeyframe(1, duration: 0.3)
                    }

                    KeyframeTrack(\.offsetY) {
                        CubicKeyframe(10, duration: 0.15)
                        SpringKeyframe(-100, duration: 0.3, spring: .bouncy)
                        CubicKeyframe(-100, duration: 0.45)
                        SpringKeyframe(0, duration: 0.3, spring: .bouncy)
                    }

                    KeyframeTrack(\.rotation) {
                        CubicKeyframe(.zero, duration: 0.45)
                        CubicKeyframe(.init(degrees: -10), duration: 0.1)
                        CubicKeyframe(.init(degrees: 10), duration: 0.1)
                        CubicKeyframe(.init(degrees: -10), duration: 0.1)
                        CubicKeyframe(.init(degrees: 0), duration: 0.15)
                    }

                    KeyframeTrack(\.reflectionOpacity) {
                        CubicKeyframe(0.5, duration: 0.15)
                        CubicKeyframe(0.3, duration: 0.75)
                        CubicKeyframe(0.5, duration: 0.3)
                    }
                }

            Spacer()

            Button("Keyframe Animation") {
                isAnimating.toggle()
            }
            .fontWeight(.bold)
        }
        .padding()
    }
}

struct Keyframe {
    var scale: CGFloat = 1

    var offsetY: CGFloat = 0

    var rotation: Angle = .zero

    var reflectionOpacity: CGFloat = 0.5
}

#Preview {
    ContentView()
}
