//
//  SiteView.swift
//  SwiftCharts
//
//  Created by Jiaxin Shou on 2022/6/19.
//

import Foundation

struct SiteView: Identifiable {
    let id: UUID = .init()
    let hour: Date
    var views: Double
    var animate: Bool = false
}

private extension Date {
    func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
}

let SAMPLE_ANALYTICS: [SiteView] = [
    .init(hour: Date().updateHour(8), views: 1500),
    .init(hour: Date().updateHour(9), views: 2625),
    .init(hour: Date().updateHour(10), views: 7500),
    .init(hour: Date().updateHour(11), views: 3688),
    .init(hour: Date().updateHour(12), views: 2988),
    .init(hour: Date().updateHour(13), views: 3289),
    .init(hour: Date().updateHour(14), views: 4500),
    .init(hour: Date().updateHour(15), views: 6788),
    .init(hour: Date().updateHour(16), views: 9988),
    .init(hour: Date().updateHour(17), views: 7866),
    .init(hour: Date().updateHour(18), views: 1989),
    .init(hour: Date().updateHour(19), views: 6456),
    .init(hour: Date().updateHour(20), views: 3467),
]
