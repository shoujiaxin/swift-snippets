//
//  ContentView.swift
//  CustomKeyboard
//
//  Created by Jiaxin Shou on 2023/3/1.
//

import SwiftUI

struct ContentView: View {
    @State
    private var text: String = ""

    @FocusState
    private var showKeyboard: Bool

    var body: some View {
        VStack {
            Image(systemName: "apple.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(LinearGradient(colors: [
                            .init(red: 0.40, green: 0.37, blue: 0.83),
                            .init(red: 0.66, green: 0.64, blue: 0.96),
                        ], startPoint: .top, endPoint: .bottom))
                }

            TextField("$100.0", text: $text)
                .inputView {
                    customKeyboard
                }
                .focused($showKeyboard)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .environment(\.colorScheme, .dark)
                .padding([.horizontal, .top], 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(Color(white: 0.08).gradient)
                .ignoresSafeArea()
        }
    }

    private var customKeyboard: some View {
        LazyVGrid(columns: .init(repeating: .init(.flexible(), spacing: 10), count: 3), spacing: 10) {
            ForEach(1 ... 9, id: \.self) { index in
                keyboardButton(.text("\(index)")) {
                    if text.isEmpty {
                        text.append("$")
                    }
                    text.append("\(index)")
                }
            }

            keyboardButton(.image("delete.backward", .red)) {
                if !text.isEmpty {
                    text.removeLast()
                    if text == "$" {
                        text = ""
                    }
                }
            }

            keyboardButton(.text("0")) {
                if text.isEmpty {
                    text.append("$")
                }
                text.append("0")
            }

            keyboardButton(.image("checkmark.circle.fill", .accentColor)) {
                showKeyboard = false
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .background {
            Rectangle()
                .fill(Color(white: 0.08).gradient)
                .ignoresSafeArea()
        }
    }

    private func keyboardButton(_ value: KeyboardValue, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            Group {
                switch value {
                case let .text(str):
                    Text(str)
                        .foregroundColor(.white)
                case let .image(name, color):
                    Image(systemName: name)
                        .foregroundColor(color)
                }
            }
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .contentShape(Rectangle())
        }
    }
}

private enum KeyboardValue {
    case text(String)
    case image(String, Color)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
