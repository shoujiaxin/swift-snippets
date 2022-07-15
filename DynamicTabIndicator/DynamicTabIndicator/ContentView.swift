//
//  ContentView.swift
//  DynamicTabIndicator
//
//  Created by Jiaxin Shou on 2022/7/15.
//

import SwiftUI

struct ContentView: View {
    @State private var offset: CGFloat = 0

    @State private var selectedTab: Tab = sampleTabs.first!

    @State private var isTapped: Bool = false

    @StateObject private var gestureManager: InteractionManager = .init()

    var body: some View {
        GeometryReader { proxy in
            let screenSize = proxy.size

            ZStack(alignment: .top) {
                TabView(selection: $selectedTab) {
                    ForEach(sampleTabs) { tab in
                        GeometryReader { proxy in
                            let size = proxy.size

                            Image(tab.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipped()
                        }
                        .ignoresSafeArea()
                        .tag(tab)
                        .offsetX { value in
                            if selectedTab == tab, !isTapped {
                                offset = value - screenSize.width * CGFloat(indexOf(tab: tab))
                            }

                            if value == 0, isTapped {
                                isTapped = false
                            }

                            if isTapped, gestureManager.isInteracting {
                                isTapped = false
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear(perform: gestureManager.addGesture)
                .onDisappear(perform: gestureManager.removeGesture)

                tabBar(size: screenSize)
            }
            .frame(width: screenSize.width, height: screenSize.height)
        }
    }

    private func indexOf(tab: Tab) -> Int {
        sampleTabs.firstIndex(of: tab) ?? 0
    }

    private func tabBar(size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("Dynamic Tabs")
                .font(.title.bold())
                .foregroundColor(.white)

//            // Type 1
//            HStack(spacing: 0) {
//                ForEach(sampleTabs) { tab in
//                    Text(tab.name)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            .background(alignment: .bottomLeading) {
//                Capsule()
//                    .fill(.white)
//                    .frame(width: (size.width - 30) / CGFloat(sampleTabs.count), height: 4)
//                    .offset(x: tabOffset(size: size, padding: 30), y: 12)
//            }

            // Type 2
            HStack(spacing: 0) {
                ForEach(sampleTabs) { tab in
                    Text(tab.name)
                        .fontWeight(.semibold)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
            }
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(.white)
                    .overlay(alignment: .leading, content: {
                        GeometryReader { _ in
                            HStack(spacing: 0) {
                                ForEach(sampleTabs) { tab in
                                    Text(tab.name)
                                        .fontWeight(.semibold)
                                        .padding(.vertical, 6)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .contentShape(Capsule())
                                        .onTapGesture {
                                            isTapped = true
                                            withAnimation(.easeInOut) {
                                                selectedTab = tab
                                                offset = -size.width * CGFloat(indexOf(tab: tab))
                                            }
                                        }
                                }
                            }
                            .offset(x: -tabOffset(size: size, padding: 30))
                        }
                        .frame(width: size.width - 30)
                    })
                    .frame(width: (size.width - 30) / CGFloat(sampleTabs.count))
                    .mask {
                        Capsule()
                    }
                    .offset(x: tabOffset(size: size, padding: 30))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .ignoresSafeArea()
        }
    }

    func tabOffset(size: CGSize, padding: CGFloat) -> CGFloat {
        (-offset / size.width) * ((size.width - padding) / CGFloat(sampleTabs.count))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - View Modifier

extension View {
    func offsetX(onChange: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader { proxy in
                let minX = proxy.frame(in: .global).minX

                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        onChange(value)
                    }
            }
        }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Universal Interaction Manager

class InteractionManager: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    @Published var isInteracting: Bool = false

    @Published var isGestureAdded: Bool = false

    func addGesture() {
        guard !isGestureAdded else {
            return
        }

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onChange(gesture:)))
        gesture.name = "UNIVERSAL"
        gesture.delegate = self

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.last?.rootViewController
        else {
            return
        }

        window.view.addGestureRecognizer(gesture)
        isGestureAdded = true
    }

    func removeGesture() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.last?.rootViewController
        else {
            return
        }

        window.view.gestureRecognizers?.removeAll(where: { gesture in
            gesture.name == "UNIVERSAL"
        })
        isGestureAdded = false
    }

    @objc
    func onChange(gesture: UIPanGestureRecognizer) {
        isInteracting = gesture.state == .changed
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        true
    }
}
