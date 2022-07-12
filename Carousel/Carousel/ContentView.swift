//
//  ContentView.swift
//  Carousel
//
//  Created by Jiaxin Shou on 2022/7/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GeometryReader { proxy in
                let topEdge = proxy.safeAreaInsets.top
                ForYou(topEdge: topEdge)
                    .padding(.top, topEdge)
                    .ignoresSafeArea(.all, edges: .top)
            }
            .tabItem {
                Label("For You", systemImage: "rectangle.portrait")
            }

            Text("Search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            Text("Following")
                .tabItem {
                    Label("Following", systemImage: "bookmark")
                }

            Text("Downloads")
                .tabItem {
                    Label("Downloads", systemImage: "square.and.arrow.down")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
