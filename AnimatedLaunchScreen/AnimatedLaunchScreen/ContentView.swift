//
//  ContentView.swift
//  AnimatedLaunchScreen
//
//  Created by Jiaxin Shou on 2022/7/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AnimatedSplashScreen(color: "SunsetOrange", logo: "SwiftLogo") {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(1 ... 5, id: \.self) { index in
                        Image("Preview\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)
            }
        } onAnimationEnd: {
            print("Animation Ended")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
