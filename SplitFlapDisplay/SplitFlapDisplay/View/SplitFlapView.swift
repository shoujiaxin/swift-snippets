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
        Text("\(number)")
    }
}

struct SplitFlapView_Previews: PreviewProvider {
    static var previews: some View {
        SplitFlapView()
    }
}
