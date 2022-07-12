//
//  MovieCardView.swift
//  Carousel
//
//  Created by Jiaxin Shou on 2022/7/12.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    let topOffset: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            // 120 is the navigation bar & safe area height
            let minY = proxy.frame(in: .global).minY - topOffset

            let progress = -minY / size.height

            let scale = max(0, 1 - progress / 3)

            let opacity = 1 - progress

            ZStack {
                Image(movie.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - 30, height: size.height - 80)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 15)
            .scaleEffect(minY < 0 ? scale : 1)
            .opacity(minY < 0 ? opacity : 1)
            .offset(y: minY < 0 ? -minY : 0)
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
}

struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCardView(movie: .init(name: "1", artwork: "Poster1"), topOffset: 0)
    }
}
