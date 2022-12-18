//
//  Sidebar.swift
//  ResponsiveUI
//
//  Created by Jiaxin Shou on 2022/12/18.
//

import SwiftUI

struct Sidebar: View {
    @Binding
    var currentMenu: String

    let prop: Properties

    var body: some View {
        let width = (prop.isLandscape ? prop.size.width : prop.size.height) / 4
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48)

                sidebarButton(icon: "tray.and.arrow.down.fill", title: "Inbox")
                    .padding(.top, 40)

                sidebarButton(icon: "paperplane", title: "Sent")

                sidebarButton(icon: "doc.fill", title: "Draft")

                sidebarButton(icon: "trash", title: "Deleted")
            }
            .padding()
            .padding(.top)
        }
        .padding(.leading, 10)
        .frame(width: min(width, 300))
        .background {
            Color("LightWhite")
                .ignoresSafeArea()
        }
    }

    private func sidebarButton(icon: String, title: String) -> some View {
        Button {
            currentMenu = title
        } label: {
            VStack {
                HStack(spacing: 10) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.black)
                        .opacity(currentMenu == title ? 1 : 0)

                    Image(systemName: icon)
                        .foregroundColor(currentMenu == title ? .init("DarkBlue") : .gray)

                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(currentMenu == title ? .black : .gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)

                Divider()
            }
        }
    }
}
