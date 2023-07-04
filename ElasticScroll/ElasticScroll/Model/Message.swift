//
//  Message.swift
//  ElasticScroll
//
//  Created by Jiaxin Shou on 2023/7/4.
//

import Foundation

struct Message: Identifiable {
    let id: UUID = .init()

    let name: String

    let imageName: String

    let content: String

    let isOnline: Bool

    let hasRead: Bool
}

let sampleMessages: [Message] = [
    .init(name: "Justice",
          imageName: "1",
          content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          isOnline: true,
          hasRead: false),
    .init(name: "Holden",
          imageName: "2",
          content: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
          isOnline: true,
          hasRead: true),
    .init(name: "Wright",
          imageName: "3",
          content: "when an unknown printer took a galley of type and scrambled it to make a type specimen book",
          isOnline: false,
          hasRead: true),
    .init(name: "Brandt",
          imageName: "4",
          content: "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages",
          isOnline: false,
          hasRead: false),
    .init(name: "Herman",
          imageName: "5",
          content: "Contrary to popular belief, Lorem Ipsum is not simply random text",
          isOnline: false,
          hasRead: false),
    .init(name: "Lally",
          imageName: "6",
          content: "It has roots in a piece of classical Latin literature from 45 BC",
          isOnline: false,
          hasRead: true),
    .init(name: "Tahlia",
          imageName: "7",
          content: "a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words",
          isOnline: false,
          hasRead: true),
    .init(name: "Eulalia",
          imageName: "8",
          content: "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested.",
          isOnline: true,
          hasRead: true),
    .init(name: "Florrie",
          imageName: "9",
          content: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout",
          isOnline: false,
          hasRead: true),
]
