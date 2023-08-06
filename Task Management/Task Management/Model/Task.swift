//
//  Task.swift
//  Task Management
//
//  Created by Jiaxin Shou on 2023/8/6.
//

import SwiftUI

struct Task: Identifiable {
    let id: UUID = .init()

    let title: String

    let creationDate: Date

    var isCompleted: Bool

    let tint: Color

    init(title: String,
         creationDate: Date = .now,
         isCompleted: Bool = false,
         tint: Color)
    {
        self.title = title
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
    }
}

let sampleTasks: [Task] = [
    .init(title: "Record Video", creationDate: .updateHour(-5), isCompleted: true, tint: .taskColor1),
    .init(title: "Redesign Website", creationDate: .updateHour(-3), tint: .taskColor2),
    .init(title: "Go for a Walk", creationDate: .updateHour(-4), tint: .taskColor3),
    .init(title: "Edit Video", creationDate: .updateHour(0), isCompleted: true, tint: .taskColor4),
    .init(title: "Publish Video", creationDate: .updateHour(2), isCompleted: true, tint: .taskColor1),
    .init(title: "Tweet about New Video", creationDate: .updateHour(1), tint: .taskColor5),
]
