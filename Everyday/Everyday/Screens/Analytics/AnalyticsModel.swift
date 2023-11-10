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

struct ViewMonth: Identifiable {
    var id = UUID()
    var date: Date
    var viewCount: Int
    var priority: Priority
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
