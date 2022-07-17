//
//  LineGraph.swift
//  CustomLineGraph
//
//  Created by Jiaxin Shou on 2022/7/18.
//

import SwiftUI

struct LineGraph: View {
    let data: [Double]

    @State private var currentPlot = ""

    @State private var offset: CGSize = .zero

    @State private var showPlot = false

    @State private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width / CGFloat(data.count - 1)
            let height = proxy.size.height

            let maxPoint = data.max() ?? 0 + 100

            let points = data.enumerated().compactMap { item -> CGPoint in
                let progress = item.element / maxPoint

                let pathWidth = width * CGFloat(item.offset)
                let pathHeight = progress * height
                return CGPoint(x: pathWidth, y: height - pathHeight)
            }

            ZStack {
                Path { path in
                    path.move(to: .zero)
                    path.addLines(points)
                }
                .strokedPath(.init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(colors: [
                        Color("Gradient1"),
                        Color("Gradient2"),
                    ], startPoint: .leading, endPoint: .trailing)
                )

                fillBackground
                    .clipShape(
                        Path { path in
                            path.move(to: .zero)
                            path.addLines(points)
                            path.addLine(to: .init(x: proxy.size.width, y: height))
                            path.addLine(to: .init(x: 0, y: height))
                        }
                    )
//                    .padding(.top, 12)
            }
            .overlay(
                // Drag indicator
                VStack(spacing: 0) {
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color("Gradient1"), in: Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > proxy.size.width - 60 ? -30 : 0)

                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 40)
                        .padding(.top)

                    Circle()
                        .fill(Color("Gradient1"))
                        .frame(width: 22, height: 22)
                        .overlay {
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        }

                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 50)
                }
                .frame(width: 80, height: 170)
                .offset(y: 70)
                .opacity(showPlot ? 1 : 0)
                .offset(offset),
                alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            showPlot = true
                        }

                        translation = value.location.x - 40
                        let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                        currentPlot = "$ \(data[index])"
                        offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                    }
                    .onEnded { _ in
                        withAnimation {
                            showPlot = false
                        }
                    }
            )
        }
        .overlay {
            VStack(alignment: .leading) {
                let max = data.max() ?? 0

                Text("$ \(Int(max))")
                    .font(.caption.bold())

                Spacer()

                Text("$ 0")
                    .font(.caption.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 10)
    }

    private var fillBackground: some View {
        LinearGradient(colors: [
            Color("Gradient2").opacity(0.3),
            Color("Gradient2").opacity(0.2),
            Color("Gradient2").opacity(0.1),
        ] + Array(repeating: Color("Gradient1").opacity(0.1), count: 4) +
            Array(repeating: Color.clear, count: 2),
        startPoint: .top, endPoint: .bottom)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
