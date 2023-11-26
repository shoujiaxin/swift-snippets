//
//  ContentView.swift
//  FullScreenPop
//
//  Created by Jiaxin Shou on 2023/11/26.
//

import SwiftUI

struct ContentView: View {
    @State
    private var isEnabled: Bool = false

    var body: some View {
        FullSwipeNavigationStack {
            List {
                Section("Sample Header") {
                    NavigationLink("Full Swipe View") {
                        List {
                            Toggle("Enable full swipe pop", isOn: $isEnabled)
                                .enableFullSwipePop(isEnabled)
                        }
                        .navigationTitle("Full Swipe View")
                    }

                    NavigationLink("Leading Swipe View") {
                        Text("")
                            .navigationTitle("Leading Swipe View")
                    }
                }
            }
            .navigationTitle("Full Swipe Pop")
        }
    }
}

#Preview {
    ContentView()
}
