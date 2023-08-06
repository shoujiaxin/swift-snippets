//
//  Item.swift
//  Task Management
//
//  Created by Jiaxin Shou on 2023/8/6.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
