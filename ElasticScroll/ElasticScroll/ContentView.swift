//
//  ContentView.swift
//  ElasticScroll
//
//  Created by Jiaxin Shou on 2023/7/4.
//

import SwiftUI

struct ContentView: View {
    @State
    private var scrollRect: CGRect = .zero

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let size = proxy.size

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 18) {
                        ForEach(sampleMessages) { message in
                            messageRow(message)
                                .elasticScroll(scrollRect: scrollRect, screenSize: size)
                        }
                    }
                    .padding(15)
                    .offsetExtractor(coordinateSpace: "ScrollView") { rect in
                        scrollRect = rect
                    }
                }
                .coordinateSpace(name: "ScrollView")
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func messageRow(_ message: Message) -> some View {
        HStack(spacing: 15) {
            ZStack {
                Color.accentColor
                    .opacity(0.5)

                Image(message.imageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            }
            .frame(width: 55)
            .clipShape(Circle())
            .overlay(alignment: .bottomTrailing) {
                Circle()
                    .fill(.green.gradient)
                    .frame(width: 16)
                    .shadow(color: .primary.opacity(0.1), radius: 5, x: 5, y: 5)
                    .opacity(message.isOnline ? 1 : 0)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(message.name)
                    .font(.callout)
                    .fontWeight(.bold)

                Text(message.content)
                    .font(.caption)
                    .foregroundStyle(message.hasRead ? .gray : .primary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ContentView()
}
