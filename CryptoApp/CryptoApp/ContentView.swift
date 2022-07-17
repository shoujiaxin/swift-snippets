//
//  ContentView.swift
//  CryptoApp
//
//  Created by Jiaxin Shou on 2022/7/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
