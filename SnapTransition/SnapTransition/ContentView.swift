//
//  ContentView.swift
//  SnapTransition
//
//  Created by Jiaxin Shou on 2023/2/6.
//

import SwiftUI

struct ContentView: View {
    @State
    private var videoFiles: [VideoFile] = files

    @State
    private var expandedID: UUID?

    @State
    private var isExpanded: Bool = false

    @Namespace
    private var namespace

    var body: some View {
        VStack(spacing: 0) {
            headerView

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: .init(repeating: .init(.flexible(), spacing: 10), count: 2), spacing: 10) {
                    ForEach($videoFiles) { $file in
                        if expandedID == file.id, isExpanded {
                            Color.clear
                                .frame(height: 300)
                        } else {
                            CardView(videoFile: $file,
                                     isExpanded: $isExpanded,
                                     animationID: namespace) {}
                                .frame(height: 300)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                                        expandedID = file.id
                                        isExpanded = true
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
            }
        }
        .overlay {
            if let expandedID, isExpanded {
                DetailView(videoFile: $videoFiles.index(expandedID),
                           isExpanded: $isExpanded,
                           animationID: namespace)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        }
    }

    private var headerView: some View {
        HStack(spacing: 12) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)

            Button {} label: {
                Image(systemName: "magnifyingglass")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .headerButtonBG()
            }

            Spacer(minLength: 0)

            Button {} label: {
                Image(systemName: "person.badge.plus")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .headerButtonBG()
            }

            Button {} label: {
                Image(systemName: "ellipsis")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .headerButtonBG()
            }
        }
        .overlay {
            Text("For You")
                .font(.title3)
                .fontWeight(.black)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}

private extension View {
    func headerButtonBG() -> some View {
        frame(width: 40, height: 40)
            .background {
                Circle()
                    .fill(.gray.opacity(0.1))
            }
    }
}

extension Binding<[VideoFile]> {
    func index(_ id: UUID) -> Binding<VideoFile> {
        let index = wrappedValue.firstIndex { $0.id == id } ?? 0
        return self[index]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
