//
//  ContentView.swift
//  AnimatedTagView
//
//  Created by Jiaxin Shou on 2023/11/12.
//

import SwiftUI

struct ContentView: View {
    @State
    private var tags: [String] = [
        "SwiftUI",
        "Swift",
        "iOS",
        "Apple",
        "Xcode",
        "WWDC",
        "Android",
        "React",
        "Flutter",
        "App",
        "Indie",
        "Developer",
        "Objective-C",
        "C",
        "C#",
        "C++",
        "iPhone",
        "iPad",
        "MacBook",
        "iPadOS",
        "macOS",
    ]

    @State
    private var selectedTags: [String] = []

    @Namespace
    private var animation

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(selectedTags, id: \.self) { tag in
                        tagView(tag, color: .pink, icon: "checkmark")
                            .matchedGeometryEffect(id: tag, in: animation)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectedTags.removeAll { $0 == tag }
                                }
                            }
                    }
                }
                .padding(.horizontal, 15)
                .frame(height: 35)
                .padding(.vertical, 15)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .overlay {
                if selectedTags.isEmpty {
                    Text("Select more than 3 tags")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            .background(.white)
            .zIndex(1)

            ScrollView(.vertical) {
                TagLayout(alignment: .center, spacing: 10) {
                    ForEach(tags.filter { !selectedTags.contains($0) }, id: \.self) { tag in
                        tagView(tag, color: .blue, icon: "plus")
                            .matchedGeometryEffect(id: tag, in: animation)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectedTags.insert(tag, at: 0)
                                }
                            }
                    }
                }
                .padding(15)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .background(.black.opacity(0.05))
            .zIndex(0)

            ZStack {
                Button("Continue") {}
                    .fontWeight(.semibold)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.pink.gradient)
                    }
                    .disabled(selectedTags.count < 3)
                    .opacity(selectedTags.count < 3 ? 0.5 : 1)
                    .padding()
            }
            .background(.white)
            .zIndex(2)
        }
        .preferredColorScheme(.light)
    }

    private func tagView(_ tag: String, color: Color, icon: String) -> some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.callout)
                .fontWeight(.semibold)

            Image(systemName: icon)
        }
        .frame(height: 35)
        .foregroundStyle(.white)
        .padding(.horizontal, 15)
        .background {
            Capsule()
                .fill(color.gradient)
        }
    }
}

#Preview {
    ContentView()
}
