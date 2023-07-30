//
//  ContentView.swift
//  CircularSlider
//
//  Created by Jiaxin Shou on 2023/7/30.
//

import SwiftUI

enum TripPicker: String, CaseIterable {
    case scaled = "Scaled"

    case normal = "Normal"
}

let colors: [Color] = [
    .red,
    .green,
    .blue,
    .orange,
    .purple,
    .gray,
    .cyan,
    .yellow,
]

struct ContentView: View {
    @State
    private var pickerType: TripPicker = .normal

    @State
    private var activeID: Color?

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $pickerType) {
                    ForEach(TripPicker.allCases, id: \.rawValue) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Spacer(minLength: 0)

                GeometryReader {
                    let size = $0.size
                    let padding = (size.width - 70) / 2

                    ScrollView(.horizontal) {
                        HStack(spacing: 35) {
                            ForEach(colors, id: \.self) { color in
                                color
                                    .frame(width: 70, height: 70)
                                    .clipShape(.circle)
                                    .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .offset(y: offset(geometryProxy))
                                            .offset(y: scale(geometryProxy) * 15)
                                    }
                                    .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                        content
//                                            .offset(y: phase.isIdentity && activeID == color ? 15 : 0)
                                            .scaleEffect(phase.isIdentity && pickerType == .scaled && activeID == color ? 1.5 : 1, anchor: .bottom)
                                    }
                            }
                        }
                        .frame(height: size.height)
                        .offset(y: -30)
                        .scrollTargetLayout()
                    }
                    .background {
                        if pickerType == .normal {
                            Circle()
                                .fill(.white.shadow(.drop(color: .black.opacity(0.2), radius: 5)))
                                .frame(width: 85, height: 85)
                                .offset(y: -15)
                        }
                    }
                    .safeAreaPadding(.horizontal, padding)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                    // FIXME: `activeID` is not updated when scrolling with `safeAreaPadding` in beta 4
                    .scrollPosition(id: $activeID)
                    .frame(height: size.height)
                }
                .frame(height: 200)
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .navigationTitle("Trip Planner")
        }
    }

    private func offset(_ geometry: GeometryProxy) -> CGFloat {
        let progress = progress(geometry)
        return 30 * abs(progress)
    }

    private func scale(_ geometry: GeometryProxy) -> CGFloat {
        let progress = min(max(progress(geometry), -1), 1)
        return 1 - abs(progress)
    }

    private func progress(_ geometry: GeometryProxy) -> CGFloat {
        let viewWidth = geometry.size.width
        let minX = geometry.bounds(of: .scrollView)?.minX ?? 0
        return minX / viewWidth
    }
}

#Preview {
    ContentView()
}
