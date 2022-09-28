//
//  ContentView.swift
//  DynamicIslandRefreshable
//
//  Created by Jiaxin Shou on 2022/9/28.
//

import SwiftUI

struct ContentView: View {
    @State private var count: Int = 5

    var body: some View {
        CustomRefreshView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                ForEach(1 ... count, id: \.self) { index in
                    Color.accentColor
                        .opacity(0.8)
                        .frame(height: 180)
                        .overlay {
                            Text("\(index)")
                                .font(.largeTitle)
                        }
                }
            }
            .padding()
        } onRefresh: {
            count += 2
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
