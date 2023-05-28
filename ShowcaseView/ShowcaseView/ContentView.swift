//
//  ContentView.swift
//  ShowcaseView
//
//  Created by Jiaxin Shou on 2023/5/28.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State
    private var region: MKCoordinateRegion = .init(
        center: .init(latitude: 37.3346, longitude: -122.0090),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    )

    var body: some View {
        TabView {
            GeometryReader { proxy in
                let safeArea = proxy.safeAreaInsets

                Map(coordinateRegion: $region)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(height: safeArea.top)
                    }
                    .ignoresSafeArea()
                    .overlay(alignment: .topTrailing) {
                        VStack {
                            Button {} label: {
                                Image(systemName: "map.fill")
                                    .padding(10)
                            }
                            .showcase(
                                order: 0,
                                title: "Style of map",
                                cornerRadius: 10
                            )

                            Button {} label: {
                                Image(systemName: "location")
                                    .padding(10)
                            }
                            .showcase(
                                order: 1,
                                title: "My current location",
                                cornerRadius: 10
                            )
                        }
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.secondary)
                        }
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding()
                    }
            }
            .tabItem {
                Image(systemName: "macbook.and.iphone")

                Text("Devices")
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)

            Text("")
                .tabItem {
                    Image(systemName: "circle.grid.2x2")

                    Text("Items")
                }

            Text("")
                .tabItem {
                    Image(systemName: "person.circle")

                    Text("Me")
                }
        }
        .overlay(alignment: .bottom) {
            HStack(spacing: 0) {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 45)
                    .showcase(
                        order: 2,
                        title: "My devices",
                        cornerRadius: 10
                    )
                    .frame(maxWidth: .infinity)

                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 45)
                    .showcase(
                        order: 4,
                        title: "My items",
                        cornerRadius: 30,
                        scale: 1.5
                    )
                    .frame(maxWidth: .infinity)

                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 45)
                    .showcase(
                        order: 3,
                        title: "Personal info",
                        cornerRadius: 10
                    )
                    .frame(maxWidth: .infinity)
            }
            .allowsTightening(false)
        }
        .modifier(ShowcaseRoot(showHighlights: true) {
            print("Finish Onboarding")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
