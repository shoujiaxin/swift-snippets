//
//  CardView.swift
//  SnapTransition
//
//  Created by Jiaxin Shou on 2023/2/6.
//

import AVKit
import SwiftUI

struct CardView<Overlay: View>: View {
    @Binding
    var videoFile: VideoFile

    @Binding
    var isExpanded: Bool

    let animationID: Namespace.ID

    let isDetailView: Bool

    let overlay: Overlay

    init(videoFile: Binding<VideoFile>,
         isExpanded: Binding<Bool>,
         animationID: Namespace.ID,
         isDetailView: Bool = false,
         @ViewBuilder overlay: () -> Overlay)
    {
        _videoFile = videoFile
        _isExpanded = isExpanded
        self.animationID = animationID
        self.isDetailView = isDetailView
        self.overlay = overlay()
    }

    private var scale: CGFloat {
        let yOffset = max(videoFile.offset.height, 0)
        let progress = min(yOffset / screenSize.height, 0.4)
        return isExpanded ? 1 - progress : 1
    }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            if let thumbnail = videoFile.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(videoFile.isPlaying ? 0 : 1)
                    .frame(width: size.width, height: size.height)
                    .overlay {
                        if videoFile.isPlaying, isDetailView {
                            CustomVideoPlayer(player: videoFile.player)
                                .transition(.identity)
                        }
                    }
                    .overlay {
                        overlay
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .scaleEffect(scale)
            } else {
                Color.clear
                    .task {
                        guard videoFile.thumbnail == nil else {
                            return
                        }
                        do {
                            videoFile.thumbnail = try await extractImageAt(time: .zero, size: screenSize)
                        } catch {
                            print("Failed to extract thumbnail, \(error)")
                        }
                    }
            }
        }
        .matchedGeometryEffect(id: videoFile.id, in: animationID)
        .offset(videoFile.offset)
        .offset(y: videoFile.offset.height * -0.7)
    }

    private func extractImageAt(time: CMTime, size: CGSize) async throws -> UIImage {
        let asset = AVAsset(url: videoFile.url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = size

        let cgImage = try await generator.image(at: time).image
        guard let colorCorrectedImage = cgImage.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else {
            return UIImage(cgImage: cgImage)
        }
        return UIImage(cgImage: colorCorrectedImage)
    }
}

extension View {
    var screenSize: CGSize {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let screen = windowScene.windows.first?.screen
        else {
            return .zero
        }
        return screen.bounds.size
    }
}
