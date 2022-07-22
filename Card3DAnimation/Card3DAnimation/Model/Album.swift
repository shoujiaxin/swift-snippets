//
//  Album.swift
//  Card3DAnimation
//
//  Created by Jiaxin Shou on 2022/7/22.
//

import Foundation

struct Album: Identifiable {
    let id = UUID()

    let name: String

    let imageName: String

    let isLiked: Bool

    init(name: String, imageName: String, isLiked: Bool = false) {
        self.name = name
        self.imageName = imageName
        self.isLiked = isLiked
    }
}

let stackAlbums: [Album] = [
    .init(name: "Plagiarism", imageName: "Album1"),
    .init(name: "note", imageName: "Album2"),
    .init(name: "Lemon - Single", imageName: "Album3"),
    .init(name: "The Orange Box", imageName: "Album4"),
    .init(name: "Your Name", imageName: "Album5"),
]

let albums: [Album] = [
    .init(name: "Plagiarism", imageName: "Album1", isLiked: true),
    .init(name: "note", imageName: "Album2"),
    .init(name: "Lemon - Single", imageName: "Album3"),
    .init(name: "The Orange Box", imageName: "Album4", isLiked: true),
    .init(name: "Your Name", imageName: "Album5"),
]
