//
//  Home.swift
//  CustomSidebar
//
//  Created by Jiaxin Shou on 2022/10/12.
//

import SwiftUI

struct Home: View {
    @State
    private var currentTab: String = "house"

    @Namespace
    private var animation

    var body: some View {
        HStack(spacing: 0) {
            // Sidebar menu
            VStack(spacing: 10) {
                ForEach(["house", "display", "cart", "creditcard", "list.dash.header.rectangle"], id: \.self) { image in
                    menuButton(image: image)
                }
            }
            .padding(.top, 60)
            .frame(width: 85)
            .frame(maxHeight: .infinity, alignment: .top)
            .background {
                ZStack {
                    Color.white
                        .padding(.trailing, 30)

                    Color.white
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.03), radius: 5, x: 5, y: 0)
                }
                .ignoresSafeArea()
            }

            // Home view
            VStack(spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dashboard")
                            .font(.title.bold())
                            .foregroundColor(.black)

                        Text("Payment updates")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundColor(.black)

                        TextField("Search", text: .constant(""))
                            .frame(width: 150)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(.white)
                    .clipShape(Capsule())
                }

                ScrollView(.vertical, showsIndicators: false) {
                    recentsView
                }
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(width: bounds.width / 1.75, height: bounds.height - 130, alignment: .leading)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .buttonStyle(.borderless)
        .textFieldStyle(.plain)
    }

    @ViewBuilder
    private func menuButton(image: String) -> some View {
        Image(systemName: image)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(currentTab == image ? .black : .gray)
            .frame(width: 22, height: 22)
            .frame(width: 80, height: 50)
            .overlay(alignment: .trailing) {
                HStack {
                    if currentTab == image {
                        Capsule()
                            .fill(.black)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                            .frame(width: 2, height: 40)
                            .offset(x: 2)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    currentTab = image
                }
            }
    }

    private var recentsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(recents) { recent in
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: recent.image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 26, height: 26)
                                .foregroundColor(.black)

                            Spacer()

                            Image(systemName: "ellipsis")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .rotationEffect(.degrees(90), anchor: .center)
                                .foregroundColor(.gray)
                        }

                        Text(recent.title)
                            .foregroundColor(.gray)

                        Text(recent.price)
                            .font(.title2.bold())
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(width: 150)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.03), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.03), radius: 5, x: -5, y: -5)
                }
            }
            .padding()
        }
    }

    private var analyticsView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Balance")
                .font(.callout)
                .foregroundColor(.gray)

            Text("$1500")
                .font(.title.bold())
                .foregroundColor(.black)
        }
    }
}

extension View {
    var bounds: CGRect {
        NSScreen.main!.visibleFrame
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
