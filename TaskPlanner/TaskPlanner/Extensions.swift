//
//  Extensions.swift
//  TaskPlanner
//
//  Created by Jiaxin Shou on 2023/1/8.
//

import SwiftUI

extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }

    func vAlign(_ alignment: Alignment) -> some View {
        frame(maxHeight: .infinity, alignment: alignment)
    }
}

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension Calendar {
    struct Weekday: Identifiable {
        let id: UUID = .init()

        let string: String

        let date: Date

        let isToday: Bool
    }

    /// Returns days of current week in an array
    var currentWeek: [Weekday] {
        guard let firstWeekday = dateInterval(of: .weekOfMonth, for: .init())?.start else {
            return []
        }

        var week: [Weekday] = []
        for index in 0 ..< 7 {
            if let day = date(byAdding: .day, value: index, to: firstWeekday) {
                let weekdaySymbol = day.toString("EEEE")
                let isToday = isDateInToday(day)
                week.append(.init(string: weekdaySymbol, date: day, isToday: isToday))
            }
        }
        return week
    }

    /// Returns 24 hours of today
    var hours: [Date] {
        let startOfDay = self.startOfDay(for: Date())

        var hours: [Date] = []
        for index in 0 ..< 24 {
            if let date = date(byAdding: .hour, value: index, to: startOfDay) {
                hours.append(date)
            }
        }
        return hours
    }
}
