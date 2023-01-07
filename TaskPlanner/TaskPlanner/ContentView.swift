//
//  ContentView.swift
//  TaskPlanner
//
//  Created by Jiaxin Shou on 2023/1/7.
//

import SwiftUI

struct ContentView: View {
    @State
    private var currentDay: Date = .now

    @State
    private var tasks: [Task] = sampleTasks

    @State
    private var addNewTask: Bool = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            timelineView
                .padding(15)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            headerView
        }
        .fullScreenCover(isPresented: $addNewTask) {
            AddTaskView { task in
                tasks.append(task)
            }
        }
    }

    private var timelineView: some View {
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack {
                ForEach(hours, id: \.self) { hour in
                    timelineRow(hour)
                        .id(hour)
                }
            }
            .onAppear {
                proxy.scrollTo(midHour)
            }
        }
    }

    private func timelineRow(_ hour: Date) -> some View {
        HStack(alignment: .top) {
            Text(hour.toString("h a"))
                .ubuntu(14, .regular)
                .frame(width: 45, alignment: .leading)

            let calendar = Calendar.current
            let filteredTasks = tasks.filter { task in
                calendar.dateComponents([.hour], from: hour) == calendar.dateComponents([.hour], from: task.dateAdded)
                    && calendar.isDate(task.dateAdded, inSameDayAs: currentDay)
            }

            if filteredTasks.isEmpty {
                HLine()
                    .stroke(.gray.opacity(0.5), style: .init(lineWidth: 0.5,
                                                             lineCap: .butt,
                                                             lineJoin: .bevel,
                                                             dash: [5],
                                                             dashPhase: 5))
            } else {
                VStack(spacing: 10) {
                    ForEach(filteredTasks) { task in
                        taskRow(task)
                    }
                }
            }
        }
        .hAlign(.leading)
        .padding(.vertical, 15)
    }

    private func taskRow(_ task: Task) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.name)
                .ubuntu(16, .regular)
                .foregroundColor(task.category.color)

            if !task.description.isEmpty {
                Text(task.description)
                    .ubuntu(14, .light)
                    .foregroundColor(task.category.color.opacity(0.8))
            }
        }
        .hAlign(.leading)
        .padding(12)
        .background {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(task.category.color)
                    .frame(width: 4)

                Rectangle()
                    .fill(task.category.color.opacity(0.25))
            }
        }
    }

    private var headerView: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Today")
                        .ubuntu(30, .light)

                    Text("Welcome, Jiaxin")
                        .ubuntu(14, .light)
                }
                .hAlign(.leading)

                Button {
                    addNewTask.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")

                        Text("Add Task")
                            .ubuntu(15, .regular)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background {
                        Capsule()
                            .fill(.blue.gradient)
                    }
                    .foregroundColor(.white)
                }
            }

            Text(Date().toString("MMM YYYY"))
                .ubuntu(16, .medium)
                .hAlign(.leading)
                .padding(.top, 15)

            weekRow
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                Color.white

                LinearGradient(colors: [
                    .white,
                    .clear,
                ], startPoint: .top, endPoint: .bottom)
                    .frame(height: 20)
            }
            .ignoresSafeArea()
        }
    }

    private var weekRow: some View {
        HStack(spacing: 0) {
            ForEach(Calendar.current.currentWeek) { weekday in
                let status = Calendar.current.isDate(weekday.date, inSameDayAs: currentDay)
                VStack(spacing: 6) {
                    Text(weekday.string.prefix(3))
                        .ubuntu(12, .medium)

                    Text(weekday.date.toString("dd"))
                        .ubuntu(16, status ? .medium : .regular)
                }
                .foregroundColor(status ? .blue : .gray)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentDay = weekday.date
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, -15)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
