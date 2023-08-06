//
//  ContentView.swift
//  Task Management
//
//  Created by Jiaxin Shou on 2023/8/6.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.BG)
            .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
