//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Jiaxin Shou on 2022/7/23.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
