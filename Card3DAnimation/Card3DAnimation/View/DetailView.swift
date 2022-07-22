//
//  DetailView.swift
//  Card3DAnimation
//
//  Created by Jiaxin Shou on 2022/7/22.
//

import SwiftUI

struct DetailView: View {
    let card: Album

    @Binding var currentCard: Album?

    @Binding var currentIndex: Int

    @Binding var showDetail: Bool

    @Binding var cardSize: CGSize

    @Binding var animateDetailView: Bool

    @Binding var rotateCards: Bool

    let animation: Namespace.ID

    @State private var showDetailContent: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Button {
                rotateCards = false
                withAnimation {
                    showDetailContent = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                        currentCard = nil
                        currentIndex = -1
                        showDetail = false
                        animateDetailView = false
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .top])

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    Image(card.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardSize.width, height: cardSize.height)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .rotation3DEffect(.init(degrees: showDetail && rotateCards ? -180 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                        .rotation3DEffect(.init(degrees: animateDetailView && rotateCards ? 180 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                        .matchedGeometryEffect(id: card.id, in: animation)
                        .padding(.top, 50)

                    VStack(spacing: 20) {
                        Text(card.name)
                            .font(.title3.bold())
                            .padding(.top, 10)

                        HStack(spacing: 50) {
                            Button {} label: {
                                Image(systemName: "shuffle")
                                    .font(.title2)
                            }

                            Button {} label: {
                                Image(systemName: "pause.fill")
                                    .font(.title3)
                                    .frame(width: 55, height: 55)
                                    .background(
                                        Circle()
                                            .fill(Color("Blue"))
                                    )
                                    .foregroundColor(.white)
                            }

                            Button {} label: {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.title2)
                            }
                        }
                        .foregroundColor(.primary)
                        .padding(.top, 10)

                        Text("Upcoming")
                            .font(.title3.bold())
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(albums) { album in
                            AlbumCardView(album: album)
                        }
                    }
                    .padding(.horizontal)
                    .offset(y: showDetailContent ? 0 : 300)
                    .opacity(showDetailContent ? 1 : 0)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut) {
                    showDetailContent = true
                }
            }
        }
    }
}
