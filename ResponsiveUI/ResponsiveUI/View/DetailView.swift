//
//  DetailView.swift
//  ResponsiveUI
//
//  Created by Jiaxin Shou on 2022/12/19.
//

import SwiftUI

struct DetailView: View {
    let user: User

    let props: Properties

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .opacity(props.isLandscape || !props.isSplit ? (props.isiPad ? 0 : 1) : 1)

                    Spacer()

                    Button {} label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }

                Divider()

                HStack(spacing: 15) {
                    Image(user.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55, height: 55)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Text(user.name)
                                .fontWeight(.semibold)

                            if props.isiPad {
                                Text("<ijustine@gmail.com>")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }

                        if !props.isiPad {
                            Text("<ijustine@gmail.com>")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Text(user.title)
                            .font(.title3.bold())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Now")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Text("""
                Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
                """)
                .multilineTextAlignment(.leading)
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}
