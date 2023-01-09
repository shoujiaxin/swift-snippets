//
//  ContentView.swift
//  AnimatedStickyHeader
//
//  Created by Jiaxin Shou on 2023/1/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let size = proxy.size

            Home(safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
