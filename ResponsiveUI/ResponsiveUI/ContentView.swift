//
//  ContentView.swift
//  ResponsiveUI
//
//  Created by Jiaxin Shou on 2022/12/18.
//

import SwiftUI

struct ContentView: View {
    @State
    private var currentMenu: String = "Inbox"

    @State
    private var showMenu: Bool = false

    @State
    private var excessPadding: CGFloat = 0

    @State
    private var navigationTag: UUID?

    var body: some View {
        ResponsiveView { prop in
            HStack(spacing: 0) {
                if prop.isLandscape && !prop.isSplit {
                    Sidebar(currentMenu: $currentMenu, prop: prop)
                }

                NavigationView {
                    mainView(prop: prop)
                        .navigationBarHidden(true)
                        .padding(.leading, prop.isiPad && prop.isLandscape ? excessPadding : 0)
                }
                .modifier(PaddingModifier(padding: $excessPadding, props: prop))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack(alignment: .leading) {
                    if !prop.isLandscape || prop.isSplit {
                        Color.black
                            .opacity(showMenu ? 0.25 : 0)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showMenu.toggle()
                                }
                            }

                        Sidebar(currentMenu: $currentMenu, prop: prop)
                            .offset(x: showMenu ? 0 : -300)
                    }
                }
            }
        }
        .ignoresSafeArea(.container, edges: .leading)
    }

    private func mainView(prop: Properties) -> some View {
        VStack(spacing: 0) {
            searchBar(prop: prop)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(users) { user in
                        NavigationLink(tag: user.id, selection: $navigationTag) {
                            DetailView(user: user, props: prop)
                        } label: {
                            userCardView(user: user, prop: prop)
                        }
                    }
                }
                .padding(.top, 30)
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
    }

    private func searchBar(prop: Properties) -> some View {
        HStack(spacing: 12) {
            if !prop.isLandscape || prop.isSplit {
                Button {
                    withAnimation {
                        showMenu.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }

            TextField("Search", text: .constant(""))

            Image(systemName: "magnifyingglass")
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(.white)
        }
    }

    private func userCardView(user: User, prop: Properties) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(user.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45, height: 45)

                VStack(alignment: .leading, spacing: 8) {
                    Text(user.name)
                        .fontWeight(.bold)

                    Text(user.title)
                        .font(.caption)
                }
                .foregroundColor(navigationTag == user.id && prop.isiPad ? .white : .black)
                .frame(maxWidth: .infinity, alignment: .leading)

                Text("Now")
                    .font(.caption)
                    .foregroundColor(navigationTag == user.id && prop.isiPad ? .white : .gray)
            }

            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.")
                .font(.caption)
                .foregroundColor(navigationTag == user.id && prop.isiPad ? .white : .gray)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(navigationTag == user.id && prop.isiPad ? Color("DarkBlue") : Color("LightWhite"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PaddingModifier: ViewModifier {
    @Binding
    var padding: CGFloat

    let props: Properties

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: PaddingKey.self, value: proxy.frame(in: .global))
                        .onPreferenceChange(PaddingKey.self) { value in
                            self.padding = -(value.minX / 3.3)
                        }
                }
            }
    }
}

struct PaddingKey: PreferenceKey {
    static let defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
