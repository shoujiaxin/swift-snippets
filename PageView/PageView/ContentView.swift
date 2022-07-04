//
//  ContentView.swift
//  PageView
//
//  Created by Jiaxin Shou on 2022/7/4.
//

import SwiftUI

let colors = [
    Color.red,
    Color.green,
    Color.blue,
    Color.orange,
    Color.gray,
    Color.purple,
]

struct ContentView: View {
    @State private var selected: Int = 0

    var body: some View {
        TabView(selection: $selected.animation()) {
            ForEach(colors.indices, id: \.self) { index in
                colors[index]
                    .ignoresSafeArea()
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .overlay {
            indexView
                .frame(maxWidth: 240, maxHeight: .infinity, alignment: .bottom)
        }
    }

    private var indexView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    Spacer()

                    ForEach(colors.indices, id: \.self) { index in
                        Circle()
                            .fill(colors[index])
                            .frame(width: 32, height: 32)
                            .id(index)
                            .overlay {
                                if selected == index {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    selected = index
                                }
                            }
                    }

                    Spacer()
                }
                .padding(.vertical)
            }
            .background {
                Capsule()
                    .fill(Color("AccentColor"))
            }
            .clipShape(Capsule())
            .shadow(radius: 8)
            .onChange(of: selected) { newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
