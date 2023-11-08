//
//  ContentView.swift
//  ScrollToHideTabBar
//
//  Created by Jiaxin Shou on 2023/11/8.
//

import SwiftUI

let colors: [Color] = [
    .red,
    .green,
    .blue,
    .orange,
    .purple,
    .cyan,
    .yellow,
    .brown,
    .mint,
    .mint,
]

struct ContentView: View {
    @State
    private var tabState: Visibility = .visible

    var body: some View {
        TabView {
            NavigationStack {
                TabStateScrollView(axis: .vertical, showIndicator: false, tabState: $tabState) {
                    VStack(spacing: 15) {
                        ForEach(colors, id: \.self) { color in
                            Rectangle()
                                .foregroundStyle(color)
                                .clipShape(.rect(cornerRadius: 12))
                                .frame(height: 180)
                        }
                    }
                    .padding(15)
                }
                .navigationTitle("Home")
            }
            .toolbar(tabState, for: .tabBar)
            .animation(.easeInOut(duration: 0.3), value: tabState)
            .tabItem {
                Label("Home", systemImage: "house")
            }

            Text("Favourites")
                .tabItem {
                    Label("Favourites", systemImage: "suit.heart")
                }

            Text("Notifications")
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                }

            Text("Account")
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
