//
//  MorphingView.swift
//  MorphingView
//
//  Created by Jiaxin Shou on 2022/10/1.
//

import SwiftUI

private let maxBlurRadius: CGFloat = 100

struct MorphingView: View {
    @State
    private var currentImage: CustomShape = .cloud

    @State
    private var selectedImage: CustomShape = .cloud

    @State
    private var turnOffImageMorph: Bool = false

    @State
    private var blurRadius: CGFloat = 0

    @State
    private var animateMorph: Bool = false

    var body: some View {
        VStack {
            GeometryReader { proxy in
                let size = proxy.size
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: size.width, height: size.width)
                    .clipped()
                    .overlay {
                        Rectangle()
                            .fill(.white)
                            .opacity(turnOffImageMorph ? 1 : 0)
                    }
                    .mask {
                        Canvas { context, size in
                            context.addFilter(.alphaThreshold(min: 0.5))
                            context.addFilter(.blur(radius: blurRadius >= maxBlurRadius / 2 ? maxBlurRadius - blurRadius : blurRadius))

                            context.drawLayer { ctx in
                                if let resolvedImage = context.resolveSymbol(id: 1) {
                                    ctx.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2), anchor: .center)
                                }
                            }
                        } symbols: {
                            ResolvedImage(currentImage: $currentImage)
                                .tag(1)
                        }
                        .onReceive(Timer.publish(every: 0.007, on: .main, in: .common).autoconnect()) { _ in
                            if animateMorph {
                                if blurRadius <= maxBlurRadius {
                                    blurRadius += 1

                                    if blurRadius.rounded() == maxBlurRadius / 2 {
                                        currentImage = selectedImage
                                    }
                                }

                                if blurRadius.rounded() == maxBlurRadius {
                                    blurRadius = 0
                                    animateMorph = false
                                }
                            }
                        }
                    }
            }
            .frame(height: 400)

            Picker("", selection: $selectedImage) {
                ForEach(CustomShape.allCases, id: \.rawValue) { shape in
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
            }
            .pickerStyle(.segmented)
            .allowsHitTesting(!animateMorph)
            .padding(15)
            .padding(.top, -50)
            .onChange(of: selectedImage) { _ in
                animateMorph = true
            }

            Toggle("Turn Off BG", isOn: $turnOffImageMorph)
                .fontWeight(.semibold)
                .padding(.horizontal, 15)
                .padding(.top, 10)
        }
        .offset(y: -50)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct ResolvedImage: View {
    @Binding
    var currentImage: CustomShape

    var body: some View {
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8), value: currentImage)
            .frame(width: 300, height: 300)
    }
}

struct MorphingView_Previews: PreviewProvider {
    static var previews: some View {
        MorphingView()
    }
}
