//
//  ContentView.swift
//  InfiniteStackedCarousel
//
//  Created by Jiaxin Shou on 2022/7/13.
//

import SwiftUI

struct ContentView: View {
    @State private var cards: [Card] = [
        .init(color: .blue, date: "Monday 8th November", title: "Neurobics for your \nmind."),
        .init(color: .purple, date: "Tuesday 9th November", title: "Brush up on hygine."),
        .init(color: .green, date: "Wednesday 10th November", title: "Don't skip breakfast"),
        .init(color: .pink, date: "Thursday 11th November", title: "Brush up on hygine."),
        .init(color: .yellow, date: "Friday 12th November", title: "Neurobics for your \nmind."),
    ]

    @State private var currentCard: Card? = nil

    @State private var showDetailPage: Bool = false

    @State private var showDetailContent: Bool = false

    @Namespace var animation

    var body: some View {
        VStack {
            title

            GeometryReader { proxy in
                let size = proxy.size
                let trailingCardsToShow: CGFloat = 2
                let trailingSpaceOfEachCard: CGFloat = 20

                ZStack {
                    ForEach(cards) { card in
                        InfiniteStackedCardView(cards: $cards, card: card,
                                                trailingCardsToShow: trailingCardsToShow,
                                                trailingSpaceOfEachCard: trailingSpaceOfEachCard,
                                                animation: animation,
                                                showDetailPage: $showDetailPage)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    currentCard = card
                                    showDetailPage = true
                                }
                            }
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, trailingCardsToShow * trailingSpaceOfEachCard)
                .frame(height: size.height / 1.6)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            detailPage
        }
    }

    private var title: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text("9TH OF NOV.")
                    .font(.largeTitle.bold())

                Label("New York, USA", systemImage: "location.circle")
            }

            Spacer()

            Text("Updated 1:30 PM")
                .font(.caption2)
                .fontWeight(.light)
        }
    }

    private var detailPage: some View {
        ZStack {
            if let currentCard = currentCard, showDetailPage {
                RoundedRectangle(cornerRadius: 25)
                    .fill(currentCard.color)
                    .matchedGeometryEffect(id: currentCard.id.uuidString, in: animation)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 15) {
                    Button {
                        withAnimation {
                            showDetailContent = false
                            showDetailPage = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(currentCard.date)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding(.top)

                    Text(currentCard.title)
                        .font(.title.bold())

                    ScrollView(.vertical, showsIndicators: false) {
                        Text(content)
                            .padding(.top)
                    }
                }
                .opacity(showDetailContent ? 1 : 0)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation {
                            showDetailContent = true
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private let content = "Hello Guys 🖐🖐🖐🖐 In this Video I'm going to show how to create Stylish Infinite Stacked Carousel Slider With Hero Animations Using SwiftUI 3.0 | SwiftUI Hero Animations | SwiftUI Matched Geometry Effect | SwiftUI Stacked Carousel Slider | SwiftUI Drag Gesture | SwiftUI Stacked Cards | SwiftUI  Geometry Reader | SwiftUI Complex UI | SwiftUI Custom Animations | SwiftUI Complex Animations | Swift |  SwiftUI Xcode 13 | SwiftUI for iOS 15 | Xcode 13 SwiftUI."
