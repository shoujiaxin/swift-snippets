//
//  AppDownload.swift
//  InteractiveCharts
//
//  Created by Jiaxin Shou on 2023/7/3.
//

import Foundation

struct AppDownload: Identifiable {
    let id: UUID = .init()

    let date: Date

    let count: Double

    var month: String {
        date.formatted(.dateTime.month())
    }
}

extension Date {
    init(year: Int, month: Int, day: Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        self = Calendar.current.date(from: components) ?? .now
    }
}

let sampleData: [AppDownload] = [
    .init(date: .init(year: 2023, month: 1, day: 1), count: 2500),
    .init(date: .init(year: 2023, month: 2, day: 1), count: 3500),
    .init(date: .init(year: 2023, month: 3, day: 1), count: 1500),
    .init(date: .init(year: 2023, month: 4, day: 1), count: 9500),
    .init(date: .init(year: 2023, month: 5, day: 1), count: 1950),
    .init(date: .init(year: 2023, month: 6, day: 1), count: 5100),
]

extension Array where Element == AppDownload {
    func findData(by month: String) -> Double? {
        first(where: { $0.month == month })?.count
    }

    func index(of month: String) -> Int {
        firstIndex(where: { $0.month == month }) ?? 0
    }
}
