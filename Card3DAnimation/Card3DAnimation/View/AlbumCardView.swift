//
//  AlbumCardView.swift
//  Card3DAnimation
//
//  Created by Jiaxin Shou on 2022/7/22.
//

import SwiftUI

struct AlbumCardView: View {
    let album: Album

    var body: some View {
        HStack(spacing: 12) {
            Image(album.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                Text(album.name)
                    .fontWeight(.semibold)

                Label {
                    Text("65,587,909")
                } icon: {
                    Image(systemName: "beats.headphones")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {} label: {
                Image(systemName: album.isLiked ? "suit.heart.fill" : "suit.heart")
                    .font(.title3)
                    .foregroundColor(album.isLiked ? .red : .gray)
            }

            Button {} label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
    }
}
