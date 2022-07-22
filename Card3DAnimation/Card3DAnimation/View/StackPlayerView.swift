//
//  StackPlayerView.swift
//  Card3DAnimation
//
//  Created by Jiaxin Shou on 2022/7/22.
//

import SwiftUI

struct StackPlayerView: View {
    let size: CGSize

    @Binding var currentCard: Album?

    @Binding var currentIndex: Int

    @Binding var showDetail: Bool

    @Binding var cardSize: CGSize

    @Binding var rotateCards: Bool

    @Binding var animateDetailView: Bool

    let animation: Namespace.ID

    @State private var expandCards: Bool = false

    var body: some View {
        let offsetHeight = size.height * 0.1

        ZStack {
            ForEach(stackAlbums.reversed()) { album in
                let index = stackAlbums.firstIndex(where: { $0.id == album.id }) ?? 0
                let imageSize = size.width - 20 * CGFloat(index)

                Image(album.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize / 2, height: imageSize / 2)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .rotation3DEffect(.init(degrees: expandCards && currentIndex != index ? -10 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                    .rotation3DEffect(.init(degrees: showDetail && currentIndex == index && rotateCards ? 360 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                    .matchedGeometryEffect(id: album.id, in: animation)
                    .offset(y: -20 * CGFloat(index))
                    .offset(y: expandCards ? -CGFloat(index) * offsetHeight : 0)
                    .onTapGesture {
                        if expandCards {
                            // Select current card
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                                currentCard = album
                                currentIndex = index
                                showDetail = true

                                cardSize = CGSize(width: imageSize / 2, height: imageSize / 2)

                                rotateCards = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.spring()) {
                                        animateDetailView = true
                                    }
                                }
                            }
                        } else {
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                expandCards = true
                            }
                        }
                    }
                    .offset(y: showDetail && currentIndex != index ? size.height * (currentIndex < index ? -1 : 1) : 0)
            }
        }
        .offset(y: expandCards ? 2 * offsetHeight : 0)
        .frame(width: size.width, height: size.height)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                expandCards.toggle()
            }
        }
    }
}
