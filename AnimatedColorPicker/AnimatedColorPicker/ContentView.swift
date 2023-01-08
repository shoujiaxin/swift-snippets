//
//  ContentView.swift
//  AnimatedColorPicker
//
//  Created by Jiaxin Shou on 2023/1/8.
//

import SwiftUI

struct ContentView: View {
    @State
    private var currentItem: ColorValue?

    @State
    private var expandCard: Bool = false

    @State
    private var moveCardDown: Bool = false

    @State
    private var animateContent: Bool = false

    @Namespace
    private var animation

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let safeArea = proxy.safeAreaInsets

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(sampleColors) { color in
                        cardView(item: color, rectSize: size)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 15)
            }
            .safeAreaInset(edge: .top) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(height: safeArea.top + 5)
                    .overlay {
                        Text("Color Picker")
                            .fontWeight(.semibold)
                            .opacity(0.8)
                    }
                    .overlay(alignment: .trailing) {
                        Text("v1.0.0")
                            .font(.caption)
                            .padding(.trailing, 10)
                    }
            }
            .ignoresSafeArea(.container, edges: .all)
            .overlay {
                if let currentItem, expandCard {
                    detailView(item: currentItem, rectSize: size)
                        // TODO: Why transition?
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: 10)))
                }
            }
        }
        .frame(width: 380, height: 500)
    }

    private func colorView(item: ColorValue) -> some View {
        Rectangle()
            .overlay {
                Rectangle()
                    .fill(item.color.gradient)
            }
            .overlay {
                Rectangle()
                    .fill(item.color.opacity(0.5).gradient)
                    .rotationEffect(.init(degrees: 180))
            }
            .matchedGeometryEffect(id: item.id, in: animation)
    }

    @ViewBuilder
    private func cardView(item: ColorValue, rectSize: CGSize) -> some View {
        let tappedCard = item.id == currentItem?.id && moveCardDown

        if !(item.id == currentItem?.id && expandCard) {
            colorView(item: item)
                .overlay {
                    colorDetail(item: item, rectSize: rectSize)
                }
                .frame(height: 110)
                .contentShape(Rectangle())
                .offset(y: tappedCard ? 30 : 0)
                .zIndex(tappedCard ? 100 : 0)
                .onTapGesture {
                    currentItem = item
                    withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.4)) {
                        moveCardDown = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                            expandCard = true
                        }
                    }
                }
        } else {
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 110)
        }
    }

    private func colorDetail(item: ColorValue, rectSize: CGSize) -> some View {
        HStack {
            Text("#\(item.colorCode)")
                .font(.title.bold())
                .foregroundColor(.white)

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Hexadecimal")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(width: rectSize.width * 0.3, alignment: .leading)
        }
        .padding([.leading, .vertical], 15)
        .matchedGeometryEffect(id: item.id.uuidString + "DETAIL", in: animation)
    }

    private func detailView(item: ColorValue, rectSize: CGSize) -> some View {
        colorView(item: item)
            .ignoresSafeArea()
            .overlay(alignment: .top) {
                colorDetail(item: item, rectSize: rectSize)
            }
            .overlay {
                detailViewContent(item: item)
            }
    }

    private func detailViewContent(item: ColorValue) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.white)
                .frame(height: 1)
                .scaleEffect(x: animateContent ? 1 : 0.001, anchor: .leading)
                .padding(.top, 60)

            VStack(spacing: 30) {
                let rgbColor = NSColor(item.color).rgb
                customProgressView(value: rgbColor.red, label: "Red")
                customProgressView(value: rgbColor.green, label: "Green")
                customProgressView(value: rgbColor.blue, label: "Blue")
            }
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .light)
            }
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 100)
            .animation(.easeInOut(duration: 0.5).delay(animateContent ? 0.2 : 0), value: animateContent)
            .padding(.top, 30)
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity, alignment: .top)

            HStack(spacing: 15) {
                Text("Copy Code")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 30)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
                    .onTapGesture {
                        NSPasteboard.general.setString("#\(item.colorCode)", forType: .string)
                    }

                Text("Dismiss")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 30)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            animateContent = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                expandCard = false
                                moveCardDown = false
                            }
                        }
                    }
            }
            .padding(.bottom, 40)
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 150)
            .animation(.easeInOut(duration: 0.5).delay(animateContent ? 0.3 : 0), value: animateContent)
        }
        .padding(.horizontal, 15)
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            withAnimation(.easeInOut.delay(0.2)) {
                animateContent = true
            }
        }
    }

    private func customProgressView(value: CGFloat, label: String) -> some View {
        HStack(spacing: 15) {
            Text(label)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 40, alignment: .leading)

            GeometryReader { proxy in
                let size = proxy.size

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.black.opacity(0.75))

                    Capsule()
                        .fill(.white)
                        .frame(width: animateContent ? size.width * value : 0)
                }
            }
            .frame(height: 8)

            Text("\(Int(value * 255.0))")
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
