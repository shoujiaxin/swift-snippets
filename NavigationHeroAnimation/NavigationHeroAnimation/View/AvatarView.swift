//
//  AvatarView.swift
//  NavigationHeroAnimation
//
//  Created by Jiaxin Shou on 2023/7/22.
//

import SwiftUI

struct AvatarView: View {
    let profile: Profile

    let size: CGSize

    var body: some View {
        Image(profile.avatar)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .background {
                Color.green.opacity(0.8)
            }
            .overlay {
                LinearGradient(colors: [
                    .clear,
                    .clear,
                    .clear,
                    .white.opacity(0.1),
                    .white.opacity(0.5),
                    .white.opacity(0.9),
                    .white,
                ], startPoint: .top, endPoint: .bottom)
                    .opacity(size.width > 60 ? 1 : 0)
            }
            .clipShape(.rect(cornerRadius: size.width > 60 ? 0 : size.width / 2))
    }
}

#Preview {
    AvatarView(profile: profiles[0], size: .init(width: 60, height: 60))
}

#Preview {
    AvatarView(profile: profiles[0], size: .init(width: 300, height: 300))
}
