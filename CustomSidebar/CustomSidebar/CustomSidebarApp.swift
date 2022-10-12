//
//  CustomSidebarApp.swift
//  CustomSidebar
//
//  Created by Jiaxin Shou on 2022/10/12.
//

import SwiftUI

@main
struct CustomSidebarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .windowStyle(.hiddenTitleBar)
    }
}

extension NSTextField {
    override open var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
