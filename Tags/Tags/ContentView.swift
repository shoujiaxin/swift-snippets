//
//  ContentView.swift
//  Tags
//
//  Created by Jiaxin Shou on 2022/6/19.
//

import SwiftUI

struct ContentView: View {
    @State private var tags: [Tag] = SAMPLE_TAGS.compactMap { .init(name: $0) }

    @State private var alignmentValue: Int = 0

    @State private var text: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $alignmentValue) {
                    Text("Leading")
                        .tag(0)

                    Text("Center")
                        .tag(1)

                    Text("Trailing")
                        .tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 20)

                ScrollView {
                    TagView(alignment: alignmentValue == 0 ? .leading : alignmentValue == 1 ? .center : .trailing, spacing: 20) {
                        ForEach($tags) { $tag in
                            Toggle(tag.name, isOn: $tag.isSelected)
                                .toggleStyle(.button)
                                .buttonStyle(.bordered)
                                .tint(tag.isSelected ? .red : .gray)
                        }
                    }
                    .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6), value: alignmentValue)
                }

                HStack {
                    TextField("Tag", text: $text, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1 ... 5)

                    Button("Add") {
                        withAnimation(.spring()) {
                            tags.append(.init(name: text))
                            text = ""
                        }
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 6))
                    .tint(.red)
                    .disabled(text.isEmpty)
                }
            }
            .padding(15)
            .navigationTitle("Layout")
        }
    }
}

struct TagView: Layout {
    var alignment: Alignment = .center

    var spacing: CGFloat = 10

    init(alignment: Alignment, spacing: CGFloat) {
        self.alignment = alignment
        self.spacing = spacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews _: Subviews, cache _: inout ()) -> CGSize {
        .init(width: proposal.width ?? 0, height: proposal.height ?? 0)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width

        // MARK: - Method 1

//        subviews.forEach { view in
//            let viewSize = view.sizeThatFits(proposal)
//            if origin.x + viewSize.width + spacing > maxWidth {
//                origin.x = bounds.origin.x
//                origin.y += viewSize.height + spacing
//
//                view.place(at: origin, proposal: proposal)
//                origin.x += viewSize.width + spacing
//            } else {
//                view.place(at: origin, proposal: proposal)
//                origin.x += viewSize.width + spacing
//            }
//        }

        // MARK: - Method 2

        var row: ([LayoutSubviews.Element], Double) = ([], 0.0)
        var rows: [([LayoutSubviews.Element], Double)] = []

        subviews.forEach { view in
            let viewSize = view.sizeThatFits(proposal)
            if origin.x + viewSize.width + spacing > maxWidth {
                row.1 = bounds.maxX - origin.x + bounds.minX + spacing
                rows.append(row)
                row.0.removeAll()

                origin.x = bounds.origin.x

                row.0.append(view)
                origin.x += viewSize.width + spacing
            } else {
                row.0.append(view)
                origin.x += viewSize.width + spacing
            }
        }

        if !row.0.isEmpty {
            row.1 = bounds.maxX - origin.x + bounds.minX + spacing
            rows.append(row)
        }

        origin = bounds.origin

        rows.forEach { row in
            switch alignment {
            case .leading: origin.x = bounds.minX
            case .trailing: origin.x = row.1
            case .center: origin.x = row.1 / 2
            default: break
            }
            row.0.forEach { view in
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                origin.x += viewSize.width + spacing
            }
            let maxHeight = row.0.compactMap { $0.sizeThatFits(proposal).height }.max() ?? 0
            origin.y += maxHeight + spacing
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
