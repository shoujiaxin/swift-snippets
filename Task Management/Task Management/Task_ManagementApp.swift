//
//  Task_ManagementApp.swift
//  Task Management
//
//  Created by Jiaxin Shou on 2023/8/6.
//

import SwiftData
import SwiftUI

@main
struct Task_ManagementApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
