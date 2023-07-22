//
//  Profile.swift
//  NavigationHeroAnimation
//
//  Created by Jiaxin Shou on 2023/7/22.
//

import Foundation

struct Profile: Identifiable {
    let id: UUID = .init()

    let username: String

    let avatar: String

    let lastMessage: String

    let lastActive: String
}

let profiles: [Profile] = [
    .init(username: "iJustine",
          avatar: "Avatar1",
          lastMessage: "Hi, Jiaxin!",
          lastActive: "10:25 PM"),
    .init(username: "Jenna Ezarik",
          avatar: "Avatar2",
          lastMessage: "Nothing!",
          lastActive: "06:23 AM"),
    .init(username: "Emily",
          avatar: "Avatar3",
          lastMessage: "Binge Watching...",
          lastActive: "09:36 AM"),
    .init(username: "Julie",
          avatar: "Avatar4",
          lastMessage: "404 Page Not Found!",
          lastActive: "11:00 PM"),
    .init(username: "Kaviya",
          avatar: "Avatar5",
          lastMessage: "Do not Disturb",
          lastActive: "10:05 AM"),
]
