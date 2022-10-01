//
//  ContentView.swift
//  MorphingView
//
//  Created by Jiaxin Shou on 2022/10/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MorphingView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
