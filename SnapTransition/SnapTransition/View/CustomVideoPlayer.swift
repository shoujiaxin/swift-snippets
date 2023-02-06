//
//  CustomVideoPlayer.swift
//  SnapTransition
//
//  Created by Jiaxin Shou on 2023/2/8.
//

import AVKit
import SwiftUI

struct CustomVideoPlayer: UIViewControllerRepresentable {
    typealias UIViewControllerType = AVPlayerViewController

    let player: AVPlayer

    func makeUIViewController(context _: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context _: Context) {
        uiViewController.player = player
    }
}
