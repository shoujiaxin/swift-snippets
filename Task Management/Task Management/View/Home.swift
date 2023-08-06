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
                    .foregroundStyle(Color.accentColor)

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
        .padding(15)
        .hSpacing(.leading)
    }
}

#Preview {
    Home()
}
