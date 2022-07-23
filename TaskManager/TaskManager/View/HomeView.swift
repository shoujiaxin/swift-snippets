//
//  HomeView.swift
//  TaskManager
//
//  Created by Jiaxin Shou on 2022/7/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: TaskViewModel = .init()

    @Namespace private var animation

    @FetchRequest(entity: Task.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)],
                  predicate: nil,
                  animation: .easeInOut)
    private var tasks: FetchedResults<Task>

    @Environment(\.self) private var env

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back")
                        .font(.callout)

                    Text("Here's Update Today.")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)

                customSegmentedBar
                    .padding(.top, 5)

                taskView
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            Button {
                viewModel.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $viewModel.openEditTask) {
            viewModel.resetTaskData()
        } content: {
            AddNewTaskView()
                .environmentObject(viewModel)
        }
    }

    private var customSegmentedBar: some View {
        HStack(spacing: 10) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(viewModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background {
                        if viewModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            viewModel.currentTab = tab
                        }
                    }
            }
        }
    }

    private var taskView: some View {
        // TODO: filter tasks
        LazyVStack(spacing: 20) {
            ForEach(tasks) { task in
                taskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    func taskRowView(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.3))
                    }

                Spacer()

                if !task.isCompleted && viewModel.currentTab != .failed {
                    Button {
                        viewModel.editTask = task
                        viewModel.openEditTask = true
                        viewModel.setupTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
            }

            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)

            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)

                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if !task.isCompleted && viewModel.currentTab != .failed {
                    Button {
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Blue"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
