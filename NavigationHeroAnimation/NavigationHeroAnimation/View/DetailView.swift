//
//  DetailView.swift
//  NavigationHeroAnimation
//
//  Created by Jiaxin Shou on 2023/7/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var profile: Profile?

    @Binding var pushView: Bool

    @Binding var hideView: (Bool, Bool)

    var body: some View {
        if let profile {
            VStack {
                GeometryReader { geometry in
                    let size = geometry.size

                    VStack {
                        if hideView.0 {
                            AvatarView(profile: profile, size: size)
                                .overlay(alignment: .top) {
                                    ZStack {
                                        Button {
                                            hideView.0 = false
                                            hideView.1 = false
                                            pushView = false

                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                self.profile = nil
                                            }
                                        } label: {
                                            Image(systemName: "xmark")
                                                .foregroundStyle(.white)
                                                .padding(10)
                                                .background(.black, in: .circle)
                                                .contentShape(.circle)
                                        }
                                        .padding(15)
                                        .padding(.top, 40)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                                        Text(profile.username)
                                            .font(.title.bold())
                                            .foregroundStyle(.black)
                                            .padding(15)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                    }
                                    .opacity(hideView.1 ? 1 : 0)
                                    .animation(.snappy, value: hideView.1)
                                }
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        hideView.1 = true
                                    }
                                }
                        } else {
                            Color.clear
                        }
                    }
                    // Target view anchor
                    .anchorPreference(key: MAnchorKey.self, value: .bounds) { anchor in
                        [profile.id: anchor]
                    }
                }
                .frame(height: 400)
                .ignoresSafeArea()

                Spacer(minLength: 0)
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    hideView.0 = true
                }
            }
        }
    }
}

#Preview {
    DetailView(
        profile: .constant(profiles[0]),
        pushView: .constant(true),
        hideView: .constant((false, false))
    )
}
