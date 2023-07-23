//
//  Task.swift
//  DragDropList
//
//  Created by Jiaxin Shou on 2023/7/23.
//

import Foundation

struct Task: Identifiable {
    enum Status {
        case todo

        case doing

        case done
    }

    let id: UUID = .init()

    let title: String

    var status: Status
}
