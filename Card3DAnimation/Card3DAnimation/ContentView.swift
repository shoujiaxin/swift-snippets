//
//  ContentView.swift
//  Card3DAnimation
//
//  Created by Jiaxin Shou on 2022/7/22.
//

import SwiftUI

struct ContentView: View {
    @State private var currentCard: Album?

    @State private var currentIndex: Int = -1

    @State private var showDetail: Bool = false

    @State private var cardSize: CGSize = .zero

    @State private var animateDetailView: Bool = false

    @State private var rotateCards: Bool = false

    @Namespace private var animation

    var body: some View {
        VStack {
            HStack {
                Button {} label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.title2)
                }

                Spacer()

                Button {} label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
            }
            .foregroundColor(.primary)
            .padding(.horizontal)
            .overlay {
                Text("My Playlist")
                    .fontWeight(.semibold)
            }

            GeometryReader { proxy in
                let size = proxy.size
                StackPlayerView(size: size,
                                currentCard: $currentCard,
                                currentIndex: $currentIndex,
                                showDetail: $showDetail,
                                cardSize: $cardSize,
                                rotateCards: $rotateCards,
                                animateDetailView: $animateDetailView,
                                animation: animation)
                    .frame(width: size.width, height: size.height, alignment: .center)
            }

            VStack(alignment: .leading, spacing: 15) {
                Text("Recently Played")
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(albums) { album in
                            Image(album.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 95, height: 95)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if let currentCard, showDetail {
                ZStack {
                    Color(uiColor: UIColor.systemBackground)
                        .ignoresSafeArea()

                    DetailView(card: currentCard,
                               currentCard: $currentCard,
                               currentIndex: $currentIndex,
                               showDetail: $showDetail,
                               cardSize: $cardSize,
                               animateDetailView: $animateDetailView,
                               rotateCards: $rotateCards,
                               animation: animation)
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
