//
//  SplitFlapView.swift
//  SplitFlapDisplay
//
//  Created by Jiaxin Shou on 2023/1/15.
//

import SwiftUI

struct SplitFlapView: View {
    @State
    private var number: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: cardWidth, height: cardHeight)
                    .cornerRadius(cardCornerRadius, corners: [.topLeft, .topRight])

                Color.clear
                    .frame(width: cardWidth, height: cardSpacing)
            }

            VStack(spacing: 0) {
                Color.clear
                    .frame(width: cardWidth, height: cardSpacing)

                Rectangle()
                    .frame(width: cardWidth, height: cardHeight)
                    .cornerRadius(cardCornerRadius, corners: [.bottomLeft, .bottomRight])
            }
        }
    }

    // MARK: - Constants

    private let cardWidth: CGFloat = 200
    private let cardHeight: CGFloat = 160
    private let cardCornerRadius: CGFloat = 20
    private let cardSpacing: CGFloat = 3
}

struct SplitFlapView_Previews: PreviewProvider {
    static var previews: some View {
        SplitFlapView()
    }
}
