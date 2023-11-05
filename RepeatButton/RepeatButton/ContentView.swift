//
//  ContentView.swift
//  RepeatButton
//
//  Created by Jiaxin Shou on 2023/11/5.
//

import SwiftUI

struct ContentView: View {
    @State
    private var count: Int = 0

    @State
    private var buttonFrames: [ButtonFrame] = []

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Button(action: {
                    if count != 0 {
                        let frame = ButtonFrame(value: count)
                        buttonFrames.append(frame)
                        toggleAnimation(frame.id, increment: false)
                    }
                }) {
                    Image(systemName: "minus")
                }
                .fontWeight(.bold)
                .buttonRepeatBehavior(.enabled)

                Text("\(count)")
                    .fontWeight(.bold)
                    .frame(width: 45, height: 45)
                    .background(.white.shadow(.drop(color: .black.opacity(0.15), radius: 5)), in: .rect(cornerRadius: 10))
                    .overlay {
                        ForEach(buttonFrames) { btFrame in
                            KeyframeAnimator(initialValue: ButtonFrame(value: 0),
                                             trigger: btFrame.triggerKeyFrame)
                            { frame in
                                Text("\(btFrame.value)")
                                    .fontWeight(.bold)
                                    .background(.black.opacity(0.4 - frame.opacity))
                                    .offset(frame.offset)
                                    .opacity(frame.opacity)
                                    .blur(radius: (1 - frame.opacity) * 10)
                            } keyframes: { _ in
                                KeyframeTrack(\.offset) {
                                    LinearKeyframe(.init(width: 0, height: -20), duration: 0.2)
                                    LinearKeyframe(.init(width: .random(in: -2 ... 2), height: -40), duration: 0.2)
                                    LinearKeyframe(.init(width: .random(in: -2 ... 2), height: .random(in: -90 ... -70)), duration: 0.4)
                                }

                                KeyframeTrack(\.opacity) {
                                    LinearKeyframe(1, duration: 0.2)
                                    LinearKeyframe(1, duration: 0.2)
                                    LinearKeyframe(0.7, duration: 0.2)
                                    LinearKeyframe(0, duration: 0.2)
                                }
                            }
                        }
                    }

                Button(action: {
                    let frame = ButtonFrame(value: count)
                    buttonFrames.append(frame)
                    toggleAnimation(frame.id)
                }) {
                    Image(systemName: "plus")
                }
                .fontWeight(.bold)
                .buttonRepeatBehavior(.enabled)
            }
        }
        .padding()
    }

    private func toggleAnimation(_ id: UUID, increment: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let index = buttonFrames.firstIndex(where: { $0.id == id }) {
                buttonFrames[index].triggerKeyFrame = true
                if increment {
                    count += 1
                } else {
                    count -= 1
                }

                removeFrame(id)
            }
        }
    }

    private func removeFrame(_ id: UUID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            buttonFrames.removeAll { $0.id == id }
        }
    }
}

struct ButtonFrame: Identifiable, Equatable {
    let id: UUID = .init()

    let value: Int

    var offset: CGSize = .zero

    var opacity: CGFloat = 1

    var triggerKeyFrame: Bool = false
}

#Preview {
    ContentView()
}
