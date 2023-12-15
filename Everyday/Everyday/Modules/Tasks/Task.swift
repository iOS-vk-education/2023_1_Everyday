//
//  Task.swift
//  Everyday
//
//  Created by user on 08.12.2023.
//

import UIKit

struct Task: Codable, Identifiable, Hashable {
    var id = UUID()
    let startTime: Date
    let endTime: Date
    let taskName: String
    let taskPriority: Int
}

enum SortingCategory: String, CaseIterable {
    case time = "По умолчанию (время начала)"
    case status = "Статус"
    case priority = "Приоритет"
}

enum SortByStatus: String, CaseIterable {
    case doneFirst = "Сначала выполненные"
    case notDoneFirst = "Сначала невыполненные"
    case overdueFirst = "Сначала просроченные"
}

enum SortByPriority: String, CaseIterable {
    case ascending = "По возрастанию"
    case descending = "По убыванию"
}

enum FilterCategory: String, CaseIterable {
    case none = "По умолчанию (выключено)"
    case status = "Статус"
    case priority = "Приоритет"
}

enum FilterByStatus: String, CaseIterable {
    case doneFirst = "Только выполненные"
    case notDoneFirst = "Только невыполненные"
    case overdueFirst = "Только просроченные"
}

enum FilterByPriority: String, CaseIterable {
    case high = "Только важные"
    case medium = "Только срочные"
    case low = "Только не важные"
    case none = "Только без приоритета"
}
