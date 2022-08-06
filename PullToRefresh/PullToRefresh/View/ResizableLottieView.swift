//
//  ResizableLottieView.swift
//  PullToRefresh
//
//  Created by Jiaxin Shou on 2022/8/6.
//

import Lottie
import SwiftUI

struct ResizableLottieView: UIViewRepresentable {
    let fileName: String

    @Binding var isPlaying: Bool

    func makeUIView(context _: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let lottieView = AnimationView(name: fileName, bundle: .main)
        lottieView.backgroundColor = .clear
        lottieView.tag = 1009
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.loopMode = .loop

        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: view.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ]

        view.addSubview(lottieView)
        view.addConstraints(constraints)

        return view
    }

    func updateUIView(_ uiView: UIViewType, context _: Context) {
        guard let view = uiView.subviews.first(where: { $0.tag == 1009 }) as? AnimationView else {
            return
        }

        if isPlaying {
            view.play()
        } else {
            view.pause()
        }
    }
}

struct ResizableLottieView_Previews: PreviewProvider {
    static var previews: some View {
        ResizableLottieView(fileName: "Loading", isPlaying: .constant(true))
            .frame(width: 200, height: 200)
    }
}
