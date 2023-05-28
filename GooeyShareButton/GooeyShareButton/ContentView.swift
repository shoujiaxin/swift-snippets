//
//  ContentView.swift
//  GooeyShareButton
//
//  Created by Jiaxin Shou on 2023/5/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            Home(size: size)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
