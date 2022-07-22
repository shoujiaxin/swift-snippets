//
//  RollingText.swift
//  RollingCounter
//
//  Created by Jiaxin Shou on 2022/7/23.
//

import SwiftUI

struct RollingText: View {
    var font: Font = .largeTitle

    var fontWeight: Font.Weight = .regular

    @Binding var value: Int

    @State private var animationRange: [Int] = []

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< animationRange.count, id: \.self) { index in
                Text("8")
                    .font(font)
                    .fontWeight(fontWeight)
                    .opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size

                            VStack(spacing: 0) {
                                ForEach(0 ... 9, id: \.self) { number in
                                    Text("\(number)")
                                        .font(font)
                                        .fontWeight(fontWeight)
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                }
                            }
                            .offset(y: -CGFloat(animationRange[index]) * size.height)
                        }
                        .clipped()
                    }
            }
        }
        .onAppear {
            animationRange = Array(repeating: 0, count: "\(value)".count)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateText()
            }
        }
        .onChange(of: value) { _ in
            let diff = "\(value)".count - animationRange.count
            if diff > 0 {
                for _ in 0 ..< diff {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        animationRange.append(0)
                    }
                }
            } else if diff < 0 {
                for _ in 0 ..< -diff {
                    withAnimation(.easeIn(duration: 0.1)) {
                        animationRange.removeLast()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                updateText()
            }
        }
    }

    private func updateText() {
        let stringValue = "\(value)"
        for (index, value) in zip(0 ..< stringValue.count, stringValue) {
            let fraction = 0.15 * Double(index)
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + min(0.5, fraction), blendDuration: 1)) {
                animationRange[index] = Int(String(value)) ?? 0
            }
        }
    }
}

struct RollingText_Previews: PreviewProvider {
    static var previews: some View {
        RollingText(value: .constant(123))
    }
}
