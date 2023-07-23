//
//  ContentView.swift
//  DragDropList
//
//  Created by Jiaxin Shou on 2023/7/23.
//

import SwiftUI

struct ContentView: View {
    @State
    private var todo: [Task] = [
        .init(title: "Do homework", status: .todo),
    ]

    @State
    private var doing: [Task] = [
        .init(title: "Play Nintendo Switch", status: .doing),
    ]

    @State
    private var done: [Task] = [
        .init(title: "Sleep", status: .done),
        .init(title: "Eat fried chicken", status: .done),
    ]

    @State
    private var draggingItem: Task?

    var body: some View {
        HStack(spacing: 2) {
            todoList

            doingList

            doneList
        }
    }

    private var todoList: some View {
        NavigationStack {
            ScrollView(.vertical) {
                taskList(tasks: todo)
            }
            .navigationTitle("TODO")
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { _, _ in
                withAnimation(.snappy) {
                    appendTask(.todo)
                }
                return true
            } isTargeted: { _ in
            }
        }
    }

    private var doingList: some View {
        NavigationStack {
            ScrollView(.vertical) {
                taskList(tasks: doing)
            }
            .navigationTitle("DOING")
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { _, _ in
                withAnimation(.snappy) {
                    appendTask(.doing)
                }
                return true
            } isTargeted: { _ in
            }
        }
    }

    private var doneList: some View {
        NavigationStack {
            ScrollView(.vertical) {
                taskList(tasks: done)
            }
            .navigationTitle("DONE")
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { _, _ in
                withAnimation(.snappy) {
                    appendTask(.done)
                }
                return true
            } isTargeted: { _ in
            }
        }
    }

    private func taskList(tasks: [Task]) -> some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            ForEach(tasks) { task in
                GeometryReader { geometry in
                    taskRow(task, size: geometry.size)
                }
                .frame(height: 45)
            }
        }
        .padding()
    }

    private func taskRow(_ task: Task, size: CGSize) -> some View {
        Text(task.title)
            .font(.callout)
            .padding(.horizontal, 15)
            .frame(width: size.width, height: size.height, alignment: .leading)
            .background(.white, in: .rect(cornerRadius: 10))
            .contentShape(.dragPreview, .rect(cornerRadius: 10))
            .draggable(task.id.uuidString) {
                Text(task.title)
                    .font(.callout)
                    .padding(.horizontal, 15)
                    .frame(width: size.width, height: size.height, alignment: .leading)
                    .background(.white)
                    .contentShape(.dragPreview, .rect(cornerRadius: 10))
                    .onAppear {
                        draggingItem = task
                    }
            }
            .dropDestination(for: String.self) { _, _ in
                draggingItem = nil
                return false
            } isTargeted: { isTargeted in
                if isTargeted, let draggingItem, draggingItem.id != task.id {
                    withAnimation(.snappy) {
                        appendTask(task.status)

                        switch task.status {
                        case .todo:
                            replaceItem(tasks: &todo, target: task, status: .todo)
                        case .doing:
                            replaceItem(tasks: &doing, target: task, status: .doing)
                        case .done:
                            replaceItem(tasks: &done, target: task, status: .done)
                        }
                    }
                }
            }
    }

    private func replaceItem(tasks: inout [Task], target: Task, status: Task.Status) {
        if let draggingItem,
           let sourceIndex = tasks.firstIndex(where: { $0.id == draggingItem.id }),
           let targetIndex = tasks.firstIndex(where: { $0.id == target.id })
        {
            var sourceItem = tasks.remove(at: sourceIndex)
            sourceItem.status = status
            tasks.insert(sourceItem, at: targetIndex)
        }
    }

    private func appendTask(_ status: Task.Status) {
        guard let draggingItem else {
            return
        }

        switch status {
        case .todo:
            if !todo.contains(where: { $0.id == draggingItem.id }) {
                var item = draggingItem
                item.status = .todo

                todo.append(item)
                doing.removeAll { $0.id == draggingItem.id }
                done.removeAll { $0.id == draggingItem.id }
            }

        case .doing:
            if !doing.contains(where: { $0.id == draggingItem.id }) {
                var item = draggingItem
                item.status = .todo

                todo.removeAll { $0.id == draggingItem.id }
                doing.append(item)
                done.removeAll { $0.id == draggingItem.id }
            }

        case .done:
            if !done.contains(where: { $0.id == draggingItem.id }) {
                var item = draggingItem
                item.status = .todo

                todo.removeAll { $0.id == draggingItem.id }
                doing.removeAll { $0.id == draggingItem.id }
                done.append(item)
            }
        }
    }
}

#Preview {
    ContentView()
}
