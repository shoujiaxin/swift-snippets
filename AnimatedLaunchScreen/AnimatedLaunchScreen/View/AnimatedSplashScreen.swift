//
//  AnimatedSplashScreen.swift
//  AnimatedLaunchScreen
//
//  Created by Jiaxin Shou on 2022/7/9.
//

import SwiftUI

struct AnimatedSplashScreen<Content: View>: View {
    let color: String

    let logo: String

    let content: Content

    let onAnimationEnd: () -> Void

    init(color: String, logo: String, @ViewBuilder content: () -> Content, onAnimationEnd: @escaping () -> Void) {
        self.color = color
        self.logo = logo
        self.content = content()
        self.onAnimationEnd = onAnimationEnd
    }

    @State private var startAnimation: Bool = false

    @State private var animateContent: Bool = false

    @Namespace private var animation

    @State private var disableControls: Bool = true

    private let barHeight: CGFloat = 60

    private let animationDuration: CGFloat = 0.65

    var body: some View {
        VStack(spacing: 0) {
            if startAnimation {
                GeometryReader { proxy in
                    let size = proxy.size

                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .fill(Color("SunsetOrange").gradient)
                                .matchedGeometryEffect(id: "SPLASHCOLOR", in: animation)
                                .frame(height: barHeight + safeArea.top)

                            Image("SwiftLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .matchedGeometryEffect(id: "SPLASHICON", in: animation)
                                .frame(width: 35, height: 35)
                                .padding(.bottom, 20)
                        }

                        content
                            .offset(y: animateContent ? 0 : size.height - (barHeight + safeArea.top))
                            .disabled(disableControls)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                .transition(.identity)
                .ignoresSafeArea(.container, edges: .all)
                .onAppear {
                    if !animateContent {
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            animateContent = true
                        }
                    }
                }
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color("SunsetOrange").gradient)
                        .matchedGeometryEffect(id: "SPLASHCOLOR", in: animation)

                    Image("SwiftLogo")
                        .matchedGeometryEffect(id: "SPLASHICON", in: animation)
                }
                .ignoresSafeArea(.container, edges: .all)
            }
        }
        .onAppear {
            if !startAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        startAnimation = true
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration - 0.05) {
                    disableControls = false
                    onAnimationEnd()
                }
            }
        }
    }
}

private extension View {
    var safeArea: UIEdgeInsets {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let safeArea = window.windows.first?.safeAreaInsets
        else {
            return .zero
        }
        return safeArea
    }
}
