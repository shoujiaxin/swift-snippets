//
//  ContentView.swift
//  NavigationHeroAnimation
//
//  Created by Jiaxin Shou on 2023/7/22.
//

import SwiftUI

struct ContentView: View {
    @State
    private var selectedProfile: Profile?

    @State
    private var pushView: Bool = false

    @State
    private var hideView: (Bool, Bool) = (false, false)

    var body: some View {
        NavigationStack {
            profileList
                .navigationTitle("Profile")
                .navigationDestination(isPresented: $pushView) {
                    DetailView(
                        profile: $selectedProfile,
                        pushView: $pushView,
                        hideView: $hideView
                    )
                }
        }
        .overlayPreferenceValue(MAnchorKey.self) { value in
            GeometryReader { geometry in
                if let selectedProfile, let anchor = value[selectedProfile.id], !hideView.0 {
                    let rect = geometry[anchor]
                    AvatarView(profile: selectedProfile, size: rect.size)
                        .offset(x: rect.minX, y: rect.minY)
                        .animation(.snappy(duration: 0.35, extraBounce: 0), value: rect)
                }
            }
        }
    }

    private var profileList: some View {
        List {
            ForEach(profiles) { profile in
                Button {
                    selectedProfile = profile
                    pushView.toggle()
                } label: {
                    HStack(spacing: 15) {
                        Color.clear
                            .frame(width: 60, height: 60)
                            // Source view anchor
                            .anchorPreference(key: MAnchorKey.self, value: .bounds) { anchor in
                                [profile.id: anchor]
                            }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(profile.username)
                                .fontWeight(.semibold)

                            Text(profile.lastMessage)
                                .font(.callout)
                                .textScale(.secondary)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Text(profile.lastActive)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
            }
        }
        .overlayPreferenceValue(MAnchorKey.self) { value in
            GeometryReader { geometry in
                ForEach(profiles) { profile in
                    if let anchor = value[profile.id], selectedProfile?.id != profile.id {
                        let rect = geometry[anchor]
                        AvatarView(profile: profile, size: rect.size)
                            .offset(x: rect.minX, y: rect.minY)
                            .allowsHitTesting(false)
                    }
                }
            }
        }
    }
}

struct MAnchorKey: PreferenceKey {
    static let defaultValue: [UUID: Anchor<CGRect>] = [:]

    static func reduce(value: inout [UUID: Anchor<CGRect>], nextValue: () -> [UUID: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

#Preview {
    ContentView()
}
