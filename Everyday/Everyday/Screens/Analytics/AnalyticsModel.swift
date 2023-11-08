//
//  AnalyticsModel.swift
//  Everyday
//
//  Created by user on 08.11.2023.
//

import Foundation

enum Priority: Int {
    case high   = 1
    case medium = 2
    case low    = 3
    case none   = 4
}

struct Tag {
    let name: String
}

struct Task {
    var title: String
    var priority: Priority = .none
    var tags: [Tag]
}
