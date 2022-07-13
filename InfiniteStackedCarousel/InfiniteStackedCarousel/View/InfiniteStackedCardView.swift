//
//  InfiniteStackedCardView.swift
//  InfiniteStackedCarousel
//
//  Created by Jiaxin Shou on 2022/7/13.
//

import SwiftUI

struct InfiniteStackedCardView: View {
    @Binding var cards: [Card]

    let card: Card

    let trailingCardsToShow: CGFloat

    let trailingSpaceOfEachCard: CGFloat

    let animation: Namespace.ID

    @Binding var showDetailPage: Bool

    @GestureState var isDragging: Bool = false

    @State private var offset: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(card.date)
                .font(.caption)
                .fontWeight(.semibold)

            Text(card.title)
                .font(.title.bold())
                .padding(.top)

            Spacer()

            Label {
                Image(systemName: "arrow.right")
            } icon: {
                Text("Read More")
            }
            .font(.system(size: 15, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(card.color)
                    .matchedGeometryEffect(id: card.id.uuidString, in: animation)
            }
        }
        .padding(.trailing, -trailingPadding)
        .padding(.vertical, trailingPadding)
        // Reverse the order of cards
        .zIndex(Double(CGFloat(cards.count) - cardIndex))
        .rotationEffect(.init(degrees: getRotation(angle: 10)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .offset(x: offset)
        .gesture(
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged { value in
                    var translation = value.translation.width
                    translation = cards.first?.id == card.id ? translation : 0
                    translation = isDragging ? translation : 0

                    // Disable right swipe
                    translation = min(translation, 0)

                    offset = translation
                }
                .onEnded { _ in

                    let width = UIScreen.main.bounds.width
                    let cardPassed = -offset > width / 2

                    withAnimation(.easeInOut(duration: 0.2)) {
                        if cardPassed {
                            offset = -width
                            removeAndPutBack()
                        } else {
                            offset = .zero
                        }
                    }
                }
        )
    }

    private var cardIndex: CGFloat {
        let index = cards.firstIndex { card in
            self.card.id == card.id
        } ?? 0
        return CGFloat(index)
    }

    private var trailingPadding: CGFloat {
        let maxPadding = trailingCardsToShow * trailingSpaceOfEachCard
        let cardPadding = cardIndex * trailingSpaceOfEachCard
        return cardIndex <= trailingCardsToShow ? cardPadding : maxPadding
    }

    private func getRotation(angle: Double) -> Double {
        let width = UIScreen.main.bounds.width - 50
        let progress = offset / width
        return Double(progress) * angle
    }

    private func removeAndPutBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var updatedCard = card
            updatedCard.id = UUID()

            cards.append(updatedCard)
            _ = withAnimation {
                cards.removeFirst()
            }
        }
    }
}
