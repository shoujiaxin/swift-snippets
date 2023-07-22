//
//  ContentView.swift
//  ReorderingGrid
//
//  Created by Jiaxin Shou on 2023/7/23.
//

import SwiftUI

struct ContentView: View {
    @State
    private var colors: [Color] = [
        .red,
        .blue,
        .purple,
        .yellow,
        .black,
        .indigo,
        .cyan,
        .brown,
        .mint,
        .orange,
    ]

    @State
    private var draggingItem: Color?

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                let columns = Array(repeating: GridItem(spacing: 10), count: 3)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(colors, id: \.self) { color in
                        GeometryReader { geometry in
                            let size = geometry.size

                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(color.gradient)
                                // Drag
                                .draggable(color) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(color)
                                        .frame(width: size.width, height: size.height)
                                        .onAppear {
                                            draggingItem = color
                                        }
                                }
                                // Drop
                                .dropDestination(for: Color.self) { _, _ in
                                    draggingItem = nil
                                    return false
                                } isTargeted: { isTargeted in
                                    if isTargeted, let draggingItem, draggingItem != color,
                                       let sourceIndex = colors.firstIndex(of: draggingItem),
                                       let targetIndex = colors.firstIndex(of: color)
                                    {
                                        withAnimation(.bouncy) {
                                            let sourceItem = colors.remove(at: sourceIndex)
                                            colors.insert(sourceItem, at: targetIndex)
                                        }
                                    }
                                }
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Movable Grid")
        }
    }
}

#Preview {
    ContentView()
}
