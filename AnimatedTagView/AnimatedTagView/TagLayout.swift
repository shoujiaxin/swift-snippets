//
//  TagLayout.swift
//  AnimatedTagView
//
//  Created by Jiaxin Shou on 2023/11/12.
//

import SwiftUI

struct TagLayout: Layout {
    let alignment: Alignment

    let spacing: CGFloat

    init(alignment: Alignment = .center, spacing: CGFloat = 10) {
        self.alignment = alignment
        self.spacing = spacing
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        let rows = generateRows(maxWidth: maxWidth, proposal: proposal, subviews: subviews)

        var height: CGFloat = 0
        for (index, row) in rows.enumerated() {
            height += row.maxHeight(proposal: proposal)
            if index < rows.count - 1 {
                height += spacing
            }
        }

        return .init(width: maxWidth, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth: maxWidth, proposal: proposal, subviews: subviews)

        rows.forEach { row in
            let contentWidth: CGFloat = row.reduce(.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                if view == row.last {
                    return partialResult + width
                } else {
                    return partialResult + width + spacing
                }
            }
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing: CGFloat = bounds.maxX - contentWidth

            switch alignment {
            case .leading:
                origin.x = leading
            case .trailing:
                origin.x = trailing
            case .center:
                origin.x = (leading + trailing) / 2
            default:
                origin.x = bounds.origin.x
            }

            row.forEach { view in
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                origin.x += viewSize.width + spacing
            }

            origin.y += row.maxHeight(proposal: proposal) + spacing
        }
    }

    private func generateRows(maxWidth: CGFloat, proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []

        var origin: CGPoint = .zero

        subviews.forEach { view in
            let viewSize = view.sizeThatFits(proposal)

            if origin.x + viewSize.width + spacing > maxWidth {
                rows.append(row)
                row.removeAll()

                origin.x = 0
            }

            row.append(view)
            origin.x += viewSize.width + spacing
        }

        if !row.isEmpty {
            rows.append(row)
        }
        return rows
    }
}

extension Array where Element == LayoutSubviews.Element {
    func maxHeight(proposal: ProposedViewSize) -> CGFloat {
        return compactMap { $0.sizeThatFits(proposal).height }.max() ?? 0
    }
}
