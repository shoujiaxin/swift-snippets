//
//  Home.swift
//  Task Management
//
//  Created by Jiaxin Shou on 2023/8/6.
//

import SwiftUI

struct Home: View {
    @State
    private var currentDate: Date = .now

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
        }
        .vSpacing(.top)
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.formatted(.dateTime.month()))
                    .foregroundStyle(.darkBlue)

                Text(currentDate.formatted(.dateTime.year()))
                    .foregroundStyle(.gray)
            }
            .font(.title.bold())

            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.gray)
        }
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing) {
            Button {} label: {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 45, height: 45)
            }
        }
        .padding(15)
        .background(.white)
    }
}

#Preview {
    Home()
}
