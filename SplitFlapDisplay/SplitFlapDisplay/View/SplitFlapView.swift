//
//  SplitFlapView.swift
//  SplitFlapDisplay
//
//  Created by Jiaxin Shou on 2023/1/15.
//

import SwiftUI

struct SplitFlapView: View, Animatable {
    @State
    private var number: Int = 0

    @State
    private var rotation: Double = 0

    var animatableData: Double {
        return rotation
    }

    var body: some View {
        VStack(spacing: 0) {
            topSplitCard

            bottomSplitCard
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1)) {
                rotation = 180
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                rotation = 0
            }
        }
    }

    private var topSplitCard: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: cardWidth, height: cardHeight)
                    .cornerRadius(cardCornerRadius, corners: [.topLeft, .topRight])

                Color.clear
                    .frame(width: cardWidth, height: cardSpacing)
            }

            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: cardWidth, height: cardHeight)
                    .cornerRadius(cardCornerRadius, corners: [.topLeft, .topRight])
                    .overlay {
                        Color.white
                            .frame(width: cardWidth, height: cardHeight)
                            .mask {
                                text(of: number)
                                    .offset(y: cardHeight / 2 + cardSpacing)
                            }
                    }

                Color.clear
                    .frame(width: cardWidth, height: cardSpacing)
            }
            .rotation3DEffect(.degrees(rotation), axis: (-1, 0, 0), anchor: .bottom, perspective: 0.25)
        }
        .zIndex(1)
    }

    private var bottomSplitCard: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(width: cardWidth, height: cardSpacing)

            Rectangle()
                .frame(width: cardWidth, height: cardHeight)
                .cornerRadius(cardCornerRadius, corners: [.bottomLeft, .bottomRight])
                .overlay {
                    Color.white
                        .frame(width: cardWidth, height: cardHeight)
                        .mask {
                            text(of: number)
                                .offset(y: -(cardHeight / 2 + cardSpacing))
                        }
                }
        }
    }

    private func text(of number: Int) -> some View {
        Text(String(number))
            .font(.system(size: fontSize, weight: .black))
    }

    // MARK: - Constants

    private let cardWidth: CGFloat = 200
    private let cardHeight: CGFloat = 160
    private let cardCornerRadius: CGFloat = 20
    private let cardSpacing: CGFloat = 2

    private let fontSize: CGFloat = 200
}

struct SplitFlapView_Previews: PreviewProvider {
    static var previews: some View {
        SplitFlapView()
    }
}
