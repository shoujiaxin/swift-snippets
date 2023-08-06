//
//  Extensions.swift
//  Task Management
//
//  Created by Jiaxin Shou on 2023/8/6.
//

import SwiftUI

extension Date {
    static func updateHour(_ value: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: value, to: .now) ?? .now
    }
}

extension View {
    func hSpacing(_ alignment: Alignment) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }

    func vSpacing(_ alignment: Alignment) -> some View {
        frame(maxHeight: .infinity, alignment: alignment)
    }
}
