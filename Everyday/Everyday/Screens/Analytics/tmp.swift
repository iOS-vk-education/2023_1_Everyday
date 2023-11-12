////
////  tmp.swift
////  Everyday
////
////  Created by user on 12.11.2023.
////
//
//import Foundation
//
//struct GridCell: Identifiable {
//    let id = UUID()
//    let name: String
//    var chartType: ChartType
//}
//
//enum Priority: Int {
//    case high   = 0  // "Important"
//    case medium = 1  // "Urgent"
//    case low    = 2  // "Low prio"
//    case none   = 3  // "Unnecessary"
//}
//
//enum ChartType: String, CaseIterable, Identifiable {
//    case bar    = "Bar"
//    case line   = "Line"
//    var id: String {
//        self.rawValue
//    }
//}
//
//struct ViewMonth: Identifiable, Hashable {
//    let id = UUID()
//    var date: Date
//    var viewCount: Int
//    var priority: Priority
//}
//
//extension Date {
//    static func from(year: Int, month: Int, day: Int) -> Date {
//        let components = DateComponents(year: year, month: month, day: day)
//        return Calendar.current.date(from: components)!
//    }
//}
//
//struct MockData {
//    
//    static let example = [ViewMonth(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .high),
//                          ViewMonth(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .high),
//                          ViewMonth(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .high),
//                          ViewMonth(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .high),
//                          ViewMonth(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .high),
//                          ViewMonth(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .high),
//                          ViewMonth(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .high),]
//    
//    static let viewMonth: [[ViewMonth]] = [
//        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .high),
//        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .high),
//        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .high),
//        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .high),
//        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .high),
//        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .high),
//        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .high),],
//        
//        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 1, priority: .medium),
//        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 2, priority: .medium),
//        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 3, priority: .medium),
//        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 4, priority: .medium),
//        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 5, priority: .medium),
//        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 6, priority: .medium),
//        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 7, priority: .medium),],
//        
//        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 7, priority: .low),
//        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .low),
//        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 5, priority: .low),
//        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 4, priority: .low),
//        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .low),
//        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 2, priority: .low),
//        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 1, priority: .low),],
//        
//        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .none),
//        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .none),
//        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .none),
//        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .none),
//        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .none),
//        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .none),
//        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .none),],
//    ]
//}
//
//
//
//
//////
//////  Task.swift
//////  Everyday
//////
//////  Created by user on 10.11.2023.
//////
////
////import Foundation
////
////struct GridCell: Identifiable {
////    let id = UUID()
////    let name: String
////    var chartType: ChartType
////}
////
////enum Priority: Int {
////    case high   = 0  // "Important"
////    case medium = 1  // "Urgent"
////    case low    = 2  // "Low prio"
////    case none   = 3  // "Unnecessary"
////}
////
////enum Status: Int {
////    case process    = 0
////    case done       = 1
////    case overdue    = 2
////}
////
////struct Tag: Hashable {
//////    let id = UUID()
////    let name: String
////}
////
////enum ChartType: String, CaseIterable, Identifiable {
////    case bar    = "Bar"
////    case line   = "Line"
////    var id: String {
////        self.rawValue
////    }
////}
////
////struct Task: Identifiable, Hashable {
////    let id = UUID()
////    let title: String
////    let priority: Priority = .none
////    let date_begin: Date
////    let date_end: Date
////    let subtasks: [Subtask] = []
////    let tags: [Tag] = []
////}
////
////struct Subtask: Hashable {
//////    let id = UUID()
////    let title: String
////    let tags: [Tag] = []
////}
////
////struct ViewMonth: Identifiable, Hashable {
////    let id = UUID()
////    var date: Date
////    var viewCount: Int
////    var priority: Priority
////}
////
////extension Date {
////    static func from(year: Int, month: Int, day: Int) -> Date {
////        let components = DateComponents(year: year, month: month, day: day)
////        return Calendar.current.date(from: components)!
////    }
////}
////
////struct MockData {
////
////    static let example = [ViewMonth(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .high),
////                          ViewMonth(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .high),
////                          ViewMonth(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .high),
////                          ViewMonth(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .high),
////                          ViewMonth(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .high),
////                          ViewMonth(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .high),
////                          ViewMonth(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .high),]
////
////    static let viewMonth: [[ViewMonth]] = [
////        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .high),
////        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .high),
////        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .high),
////        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .high),
////        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .high),
////        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .high),
////        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .high),],
////
////        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 1, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 2, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 3, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 4, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 5, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 6, priority: .medium),
////        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 7, priority: .medium),],
////
////        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 7, priority: .low),
////        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .low),
////        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 5, priority: .low),
////        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 4, priority: .low),
////        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .low),
////        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 2, priority: .low),
////        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 1, priority: .low),],
////
////        [.init(date: Date.from(year: 2023, month: 1, day: 1), viewCount: 5, priority: .none),
////        .init(date: Date.from(year: 2023, month: 2, day: 1), viewCount: 6, priority: .none),
////        .init(date: Date.from(year: 2023, month: 3, day: 1), viewCount: 2, priority: .none),
////        .init(date: Date.from(year: 2023, month: 4, day: 1), viewCount: 11, priority: .none),
////        .init(date: Date.from(year: 2023, month: 5, day: 1), viewCount: 3, priority: .none),
////        .init(date: Date.from(year: 2023, month: 6, day: 1), viewCount: 5, priority: .none),
////        .init(date: Date.from(year: 2023, month: 7, day: 1), viewCount: 10, priority: .none),],
////    ]
////}
//
