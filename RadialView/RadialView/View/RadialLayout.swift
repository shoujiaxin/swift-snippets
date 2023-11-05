//
//  RadialLayout.swift
//  RadialView
//
//  Created by Jiaxin Shou on 2023/11/5.
//

import SwiftUI

struct RadialLayout<Content, Item, ID>: View where
    Content: View,
    Item: RandomAccessCollection, Item.Element: Identifiable,
    ID: Hashable
{
    let items: Item

    let id: KeyPath<Item.Element, ID>

    let spacing: CGFloat?

    let content: (Item.Element, Int, CGFloat) -> Content

    let onIndexChange: (Int) -> Void

    @State
    private var dragRotation: Angle = .zero

    @State
    private var lastDragRotation: Angle = .zero

    @State
    private var activeIndex: Int = 0

    init(items: Item,
         id: KeyPath<Item.Element, ID>,
         spacing: CGFloat? = nil,
         content: @escaping (Item.Element, Int, CGFloat) -> Content,
         onIndexChange: @escaping (Int) -> Void)
    {
        self.items = items
        self.id = id
        self.spacing = spacing
        self.content = content
        self.onIndexChange = onIndexChange
    }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let width = size.width
            let count = CGFloat(items.count)
            let spacing: CGFloat = spacing ?? 0
            let viewSize = (width - spacing) / count * 2

            ZStack {
                ForEach(items, id: id) { item in
                    let index = fetchIndex(of: item)
                    let rotation = CGFloat(index) / count * 360

                    content(item, index, viewSize)
                        .rotationEffect(.degrees(90))
                        .rotationEffect(.degrees(-rotation))
                        .rotationEffect(-dragRotation)
                        .frame(width: viewSize, height: viewSize)
                        .offset(x: (width - viewSize) / 2)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(rotation))
                }
            }
            .frame(width: width, height: width)
            .contentShape(.rect)
            .rotationEffect(dragRotation)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translationX = value.translation.width
                        let progress = translationX / (viewSize * 2)
                        let rotationFraction = 360 / count
                        dragRotation = .degrees(rotationFraction * progress + lastDragRotation.degrees)
                        calculateIndex(count)
                    }
                    .onEnded { value in
                        let velocityX = value.velocity.width / 15
                        let translationX = value.translation.width + velocityX
                        let progress = (translationX / (viewSize * 2)).rounded()
                        let rotationFraction = 360 / count
                        withAnimation(.smooth) {
                            dragRotation = .degrees(rotationFraction * progress + lastDragRotation.degrees)
                        }
                        lastDragRotation = dragRotation
                        calculateIndex(count)
                    }
            )
        }
    }

    private func fetchIndex(of item: Item.Element) -> Int {
        if let index = items.firstIndex(where: { $0.id == item.id }) as? Int {
            return index
        }
        return 0
    }

    private func calculateIndex(_ count: CGFloat) {
        var activeIndex = (dragRotation.degrees / 360 * count)
            .rounded()
            .truncatingRemainder(dividingBy: count)
        activeIndex = abs(activeIndex)
        self.activeIndex = Int(activeIndex)
        onIndexChange(self.activeIndex)
    }
}
