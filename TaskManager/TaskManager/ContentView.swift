//
//  ContentView.swift
//  TaskManager
//
//  Created by Jiaxin Shou on 2022/7/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationTitle("Task Manager")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
