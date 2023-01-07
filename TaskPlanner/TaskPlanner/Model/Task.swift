//
//  Task.swift
//  TaskPlanner
//
//  Created by Jiaxin Shou on 2023/1/8.
//

import SwiftUI

struct Task: Identifiable {
    enum Category: String, CaseIterable {
        case bug
        case challenge
        case coding
        case idea
        case general
        case modifiers

        var color: Color {
            switch self {
            case .bug:
                return .red
            case .challenge:
                return .blue
            case .coding:
                return .orange
            case .idea:
                return .pink
            case .general:
                return .green
            case .modifiers:
                return .purple
            }
        }
    }

    let id: UUID = .init()

    let dateAdded: Date

    let name: String

    let description: String

    let category: Category
}

private let sampleDate = Calendar.current.startOfDay(for: .now)
let sampleTasks: [Task] = [
    .init(dateAdded: Calendar.current.date(byAdding: .hour, value: 8, to: sampleDate)!,
          name: "Edit video",
          description: "Learn how to edit video",
          category: .general),
    .init(dateAdded: Calendar.current.date(byAdding: .hour, value: 10, to: sampleDate)!,
          name: "Sovle issues",
          description: "GitHub bugs",
          category: .bug),
    .init(dateAdded: Calendar.current.date(byAdding: .hour, value: 14, to: sampleDate)!,
          name: "New app",
          description: "Pence",
          category: .idea),
    .init(dateAdded: Calendar.current.date(byAdding: .hour, value: 36, to: sampleDate)!,
          name: "Unit test",
          description: "Add unit tests for my apps",
          category: .coding),
    .init(dateAdded: Calendar.current.date(byAdding: .hour, value: 63, to: sampleDate)!,
          name: "Sleep",
          description: "",
          category: .general),
]
