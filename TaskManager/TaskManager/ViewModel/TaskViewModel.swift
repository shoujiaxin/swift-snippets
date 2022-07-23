//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Jiaxin Shou on 2022/7/23.
//

import CoreData
import SwiftUI

enum Tab: String, CaseIterable {
    case today = "Today"
    case upcoming = "Upcoming"
    case taskDone = "Task Done"
    case failed = "Failed"
}

class TaskViewModel: ObservableObject {
    @Published var currentTab: Tab = .today

    @Published var openEditTask: Bool = false

    @Published var taskTitle: String = ""

    @Published var taskColor: String = "Blue"

    @Published var taskDeadline: Date = .init()

    @Published var taskType: String = "Basic"

    @Published var showDatePicker: Bool = false

    @Published var editTask: Task?

    func addTask(context: NSManagedObjectContext) -> Bool {
        let task: Task
        if let editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false

        if let _ = try? context.save() {
            return true
        }
        return false
    }

    func resetTaskData() {
        taskTitle = ""
        taskColor = "Blue"
        taskDeadline = Date()
        taskType = "Basic"
    }

    func setupTask() {
        guard let editTask else {
            return
        }
        taskTitle = editTask.title ?? ""
        taskColor = editTask.color ?? "Blue"
        taskDeadline = editTask.deadline ?? Date()
        taskType = editTask.type ?? "Basic"
    }
}
