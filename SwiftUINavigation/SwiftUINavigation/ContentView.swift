//
//  ContentView.swift
//  SwiftUINavigation
//
//  Created by Jiaxin Shou on 2022/6/19.
//

import SwiftUI

enum NavigationType: String, Hashable {
    case dm = "DM VIEW"
    case camera = "CAMERA VIEW"
    case home = "HOME"
}

struct ContentView: View {
    @State private var mainStack: [NavigationType] = []

    var body: some View {
        NavigationStack(path: $mainStack) {
            TabView {
                Text("Home")
                    .tabItem {
                        Image(systemName: "house.fill")
                    }

                Text("Search")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }

                Text("Liked")
                    .tabItem {
                        Image(systemName: "suit.heart.fill")
                    }

                Text("Settings")
                    .tabItem {
                        Image(systemName: "gearshape")
                    }
            }
            .navigationTitle("Instagram")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mainStack.append(.dm)
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.callout)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        mainStack.append(.camera)
                    } label: {
                        Image(systemName: "camera")
                            .font(.callout)
                    }
                }
            }
            .navigationDestination(for: NavigationType.self) { value in
                switch value {
                case .camera:
                    VStack {
                        Text("Camera View")

                        Button("Pop") {
                            mainStack.removeLast()
                        }

                        Button("Go to DM View") {
                            mainStack.append(.dm)
                        }
                    }
                case .home: Text("Home View")
                case .dm:
                    VStack {
                        Text("DM View")
                    }

                    Button("Pop") {
                        mainStack.removeLast()
                    }

                    Button("Pop to root") {
                        mainStack.removeAll()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
