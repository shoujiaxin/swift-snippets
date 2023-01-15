//
//  SplitFlapView.swift
//  SplitFlapDisplay
//
//  Created by Jiaxin Shou on 2023/1/15.
//

import SwiftUI

struct SplitFlapView: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
    }
}

struct SplitFlapView_Previews: PreviewProvider {
    static var previews: some View {
        SplitFlapView("Hello")
    }
}
