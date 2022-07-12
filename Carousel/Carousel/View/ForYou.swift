//
//  ForYou.swift
//  Carousel
//
//  Created by Jiaxin Shou on 2022/7/12.
//

import SwiftUI

private let movies = [
    Movie(name: "1", artwork: "Poster1"),
    Movie(name: "2", artwork: "Poster2"),
    Movie(name: "3", artwork: "Poster3"),
    Movie(name: "4", artwork: "Poster4"),
    Movie(name: "5", artwork: "Poster5"),
]

struct ForYou: View {
    let topEdge: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Today For You")
                    .font(.title.bold())

                Spacer()

                Button {} label: {
                    Image(systemName: "person.circle")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .overlay(alignment: .topTrailing) {
                            Circle()
                                .fill(.red)
                                .frame(width: 13, height: 13)
                        }
                }
            }
            .padding(.horizontal)
            .frame(height: 70)

            GeometryReader { proxy in
                let size = proxy.size

                VerticalCarouselList {
                    VStack(spacing: 0) {
                        ForEach(movies) { movie in
                            MovieCardView(movie: movie, topOffset: 70 + topEdge)
                                .frame(height: size.height)
                        }
                    }
                }
            }
        }
    }
}

struct ForYou_Previews: PreviewProvider {
    static var previews: some View {
        ForYou(topEdge: 0)
    }
}
