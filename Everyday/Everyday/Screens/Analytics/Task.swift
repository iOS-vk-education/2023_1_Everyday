//
//  Task.swift
//  Everyday
//
//  Created by user on 10.11.2023.
//

import Foundation

enum Priority: String {
    case high   = "Important"
    case medium = "Urgent"
    case low    = "Low prio"
    case none   = "Unnecessary"
}

struct Tag {
    let name: String
}

struct Task {
    var title: String
    var priority: Priority = .none
    var tags: [Tag]
}

struct ViewMonth: Identifiable, Hashable {
    let id = UUID()
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

struct MockData {
    
    static let viewMonth: [[ViewMonth]] = [
        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .high),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .high),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .high),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .high),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .high),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .high),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .high),],
        
        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .medium),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .medium),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .medium),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .medium),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .medium),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .medium),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .medium),],
        
        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .low),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .low),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .low),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .low),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .low),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .low),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .low),],
        
        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .none),
        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .none),
        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .none),
        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .none),
        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .none),
        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .none),
        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .none),],
    ]
}
