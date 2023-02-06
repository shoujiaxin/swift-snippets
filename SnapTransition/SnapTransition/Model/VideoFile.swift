//
//  VideoFile.swift
//  SnapTransition
//
//  Created by Jiaxin Shou on 2023/2/6.
//

import AVKit
import Foundation

struct VideoFile: Identifiable {
    let id: UUID = .init()

    let url: URL

    var thumbnail: UIImage?

    let player: AVPlayer

    var offset: CGSize = .zero

    var isPlaying: Bool = false
}

let files: [VideoFile] = {
    [
        "Video1",
        "Video2",
    ]
    .compactMap { Bundle.main.url(forResource: $0, withExtension: "mp4") }
    .map { .init(url: $0, player: .init(url: $0)) }
}()
