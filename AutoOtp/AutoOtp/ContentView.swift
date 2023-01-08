//
//  ContentView.swift
//  AutoOtp
//
//  Created by Jiaxin Shou on 2023/1/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            OTPVerificationView()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
