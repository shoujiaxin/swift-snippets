//
//  ContentView.swift
//  RadialView
//
//  Created by Jiaxin Shou on 2023/11/5.
//

import SwiftUI

struct ContentView: View {
    @State
    private var colors: [ColorValue] = [
        .init(color: .red),
        .init(color: .yellow),
        .init(color: .green),
        .init(color: .purple),
        .init(color: .pink),
        .init(color: .orange),
        .init(color: .brown),
        .init(color: .cyan),
        .init(color: .indigo),
        .init(color: .mint),
    ]

    @State
    private var activeIndex: Int = 0

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Spacer(minLength: 0)

                    RadialLayout(items: colors, id: \.id, spacing: 100) { colorValue, index, _ in
                        Circle()
                            .foregroundStyle(colorValue.color)
                            .overlay {
                                Text("\(index)")
                                    .fontWeight(.semibold)
                            }
                    } onIndexChange: { index in
                        activeIndex = index
                    }
                    .padding(.horizontal, -100)
                    .frame(width: geometry.size.width, height: geometry.size.width / 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(15)
            .navigationTitle("Radial Layout")
        }
    }
}

#Preview {
    ContentView()
}
