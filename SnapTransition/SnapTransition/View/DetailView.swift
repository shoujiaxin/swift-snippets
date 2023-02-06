//
//  DetailView.swift
//  SnapTransition
//
//  Created by Jiaxin Shou on 2023/2/7.
//

import SwiftUI

struct DetailView: View {
    @Binding
    var videoFile: VideoFile

    @Binding
    var isExpanded: Bool

    let animationID: Namespace.ID

    @GestureState
    private var isDragging: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets

            CardView(videoFile: $videoFile,
                     isExpanded: $isExpanded,
                     animationID: animationID,
                     isDetailView: true) {
                overlayView
                    .padding(.top, safeArea.top)
                    .padding(.bottom, safeArea.bottom)
            }
            .ignoresSafeArea()
        }
        .gesture(
            DragGesture()
                .updating($isDragging) { _, state, _ in
                    state = true
                }
                .onChanged { value in
                    videoFile.offset = isDragging ? value.translation : .zero
                }
                .onEnded { value in
                    if value.translation.height > 200 {
                        videoFile.player.pause()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            videoFile.isPlaying = false
                            videoFile.player.seek(to: .zero)
                        }

                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                            videoFile.offset = .zero
                            isExpanded = false
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            videoFile.offset = .zero
                        }
                    }
                }
        )
        .task {
            try? await Task.sleep(for: .milliseconds(280))
            withAnimation(.easeInOut) {
                videoFile.isPlaying = true
                videoFile.player.play()
            }
        }
    }

    private var overlayView: some View {
        VStack {
            HStack {
                Image("Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text("iJustine")
                        .font(.callout)
                        .fontWeight(.bold)

                    Text("4 hr ago")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "bookmark")
                    .font(.title3)

                Image(systemName: "ellipsis")
                    .font(.title3)
                    .rotationEffect(.init(degrees: -90))
            }
            .foregroundColor(.white)
            .frame(maxHeight: .infinity, alignment: .top)
            .opacity(isDragging ? 0 : 1)
            .animation(.easeInOut(duration: 0.2), value: isDragging)

            Button {} label: {
                Text("View More Episodes")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .trailing) {
                Button {} label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background {
                            Circle()
                                .fill(.ultraThinMaterial)
                        }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .opacity(videoFile.isPlaying && isExpanded ? 1 : 0)
    }
}
