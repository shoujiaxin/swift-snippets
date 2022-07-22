//
//  ContentView.swift
//  RollingCounter
//
//  Created by Jiaxin Shou on 2022/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var value: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                RollingText(font: .system(size: 55),
                            fontWeight: .black,
                            value: $value)

                Button("Change Value") {
                    value = .random(in: 0 ... 999)
                }
            }
            .padding()
            .navigationTitle("Rolling Counter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
