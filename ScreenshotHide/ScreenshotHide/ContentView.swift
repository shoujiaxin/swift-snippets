//
//  ContentView.swift
//  ScreenshotHide
//
//  Created by Jiaxin Shou on 2023/7/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ScreenshotPreventView {
                        Image(.artwork)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(.rect(topLeadingRadius: 35, bottomTrailingRadius: 35))
                            .padding()
                    }
                    .navigationTitle("Artwork")
                } label: {
                    Text("Show Image")
                }

                NavigationLink {
                    List {
                        Section("API Key") {
                            ScreenshotPreventView {
                                Text("as32$fow3;ej;dfsv35asdf!@4")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }

                        Section("API Secret") {
                            ScreenshotPreventView {
                                Text("6a54sdf")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .navigationTitle("Keys")
                } label: {
                    Text("Show Security Keys")
                }
            }
            .navigationTitle("My List")
        }
    }
}

#Preview {
    ContentView()
}
