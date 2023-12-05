import Foundation

struct GridCell: Identifiable, Codable {
    var id = UUID()
    var name: String
    var chartType: ChartType
    var barUnit: BarUnit
}

enum Priority: Int {
    case high   = 0  // "Important"
    case medium = 1  // "Urgent"
    case low    = 2  // "Low prio"
    case none   = 3  // "Unnecessary"
}

enum ChartType: String, CaseIterable, Identifiable, Codable {
    case bar = "Bar"
    case line = "Line"
    var id: String {
        self.rawValue
    }
}

enum BarUnit: String, CaseIterable, Identifiable, Codable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    var id: String {
        self.rawValue
    }
}

struct TaskData: Codable, Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var priority: [Int]
    var animate: Bool = false
}

struct MockData {
    
    static let newExample: [TaskData] = [
        .init(date: Date.from(year: 2023, month: 1, day: 1), priority: [5, 1, 7, 5]),
        .init(date: Date.from(year: 2023, month: 2, day: 1), priority: [6, 2, 6, 6]),
        .init(date: Date.from(year: 2023, month: 3, day: 1), priority: [2, 3, 5, 2]),
        .init(date: Date.from(year: 2023, month: 4, day: 1), priority: [11, 4, 4, 11]),
        .init(date: Date.from(year: 2023, month: 5, day: 1), priority: [3, 5, 3, 3]),
        .init(date: Date.from(year: 2023, month: 6, day: 1), priority: [5, 6, 2, 5]),
        .init(date: Date.from(year: 2023, month: 7, day: 1), priority: [10, 7, 1, 10])
    ]
}
